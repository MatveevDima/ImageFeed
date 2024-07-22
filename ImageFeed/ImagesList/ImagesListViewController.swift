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
    
    var presenter: ImagesListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = ImagesListPresenter()
        self.presenter = presenter
        presenter.view = self
        
        presenter.viewDidLoad()
    }
}


// MARK: - UITableViewDataSource
extension ImagesListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        presenter?.configCell(for: imageListCell, with: indexPath, self)
        return imageListCell
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController : UITableViewDelegate {
    
    static let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ImagesListViewController.showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotosIfNeed(forRowAt: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ImagesListViewController.showSingleImageSegueIdentifier {
            presenter?.prepareForSegue(for: segue, sender: sender)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        presenter?.imageListCellDidTapLike(cell)
    }
}

// MARK: - ImagesListViewControllerProtocol
extension ImagesListViewController : ImagesListViewControllerProtocol {
    
    func setRowHeight(_ newValue: CGFloat) {
        tableView.rowHeight = newValue
    }
    
    func setContentInset(_ newValue: UIEdgeInsets) {
        tableView.contentInset = newValue
    }
    
    func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        tableView.performBatchUpdates(updates, completion: completion)
    }
    
    func insertRow(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.insertRows(at: indexPaths, with: animation)
    }
    
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.reloadRows(at: indexPaths, with: animation)
    }
    
    func getIndexPathForCell(_ cell: ImagesListCell) -> IndexPath? {
        tableView.indexPath(for: cell)
    }
}
