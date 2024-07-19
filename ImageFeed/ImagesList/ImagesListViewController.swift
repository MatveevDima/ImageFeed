//
//  ViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 10.07.2024.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let imagesListService = ImagesListService()
    private var imageListServiceObserver: NSObjectProtocol?
    
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
        
    }
    // шаг 2 - при загрузке первой пачки фоток - обновить таблицу новыми данными
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}


// MARK: - UITableViewDataSource
extension ImagesListViewController : UITableViewDataSource {
    // шаг 1 - знать количество ячеек на момент инициализации таблицы
    
    // шаг 3 - обновить таблицу зная новое количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    // шаг 4 - получить каждую ячейку таблицы и сконфигурировать ее
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        // По такому принципу этот метод работает для любой таблицы. Сначала нам нужно получить ячейку для определённой секции и позиции в секции, далее — привести её к нужному типу, чтобы работать с ячейкой, сконфигурировать её и вернуть ячейку из метода.
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    // шпг 4.1 - конфигурация ячейки
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard
            let imageUrl = photos[indexPath.row].thumbImageURL,
            let url = URL(string: imageUrl),
            let stubImage = UIImage(named: "Stub")
        else { return }
        
        cell.delegate = self
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: stubImage) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = photos[indexPath.row].isLiked ?? false
        let likeImage = isLiked ? UIImage(named: "Active Like") : UIImage(named: "No Active Like")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController : UITableViewDelegate {
    
    static let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ImagesListViewController.showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    // шаг 5 - после конфигурации ячейки и перед ее отображением - проверить нужно ли совершить какие-либо еще действия, например, подгрузить еще содержимого для следующих ячеек
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let photos = imagesListService.photos
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ImagesListViewController.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            guard
                let imageUrl = photos[indexPath.row].thumbImageURL,
                let url = URL(string: imageUrl)
            else {return}
            viewController.imageUrl = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        guard let photoId = photo.id,
              let isLike = photo.isLiked
        else { return }
        
        imagesListService.changeLike(photoId: photoId, isLike: !isLike) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: !isLike)
            case .failure(let error):
                print("imageListCellDidTapLike Error: \(error)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
