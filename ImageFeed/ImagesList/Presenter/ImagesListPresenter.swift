//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import UIKit

final class ImagesListPresenter {
    
    weak var view: ImagesListViewControllerProtocol?
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    private let imagesListService = ImagesListService.shared
    
    var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListPresenter : ImagesListPresenterProtocol {
    
    func viewDidLoad() {
        
        view?.setRowHeight(200)
        view?.setContentInset(UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0))
        
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
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.performBatchUpdates { [weak self] in
                
                guard let self = self else { return }
                
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                self.view?.insertRow(at: indexPaths, with: UITableView.RowAnimation.automatic)
            } completion: { _ in }
        }
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func fetchPhotosIfNeed(forRowAt indexPath: IndexPath) {
        let photos = imagesListService.photos
        if indexPath.row + 1 == photos.count {
            fetchPhotosNextPage()
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, _ on: ImagesListCellDelegate) {
        
        guard
            let imageUrl = photos[indexPath.row].thumbImageURL,
            let url = URL(string: imageUrl),
            let stubImage = UIImage(named: "Stub")
        else { return }
        
        cell.delegate = on
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: stubImage) { [weak self] _ in
            guard let self = self else { return }
            self.view?.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = photos[indexPath.row].isLiked ?? false
        let likeImage = isLiked ? UIImage(named: "Active Like") : UIImage(named: "No Active Like")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func prepareForSegue(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
        else {
            assertionFailure("Invalid segue destination")
            return
        }
        guard
            let imageUrl = photos[indexPath.row].largeImageURL,
            let url = URL(string: imageUrl)
        else {return}
        viewController.imageUrl = url
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard
            let indexPath = view?.getIndexPathForCell(cell)
        else { return }
        UIBlockingProgressHUD.show()
        
        let photo = photos[indexPath.row]
        
        guard let photoId = photo.id,
              let isLike = photo.isLiked
        else {
            UIBlockingProgressHUD.dismiss()
            return
        }
        
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
