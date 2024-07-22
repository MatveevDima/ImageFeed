//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 22.07.2024.
//

import UIKit

protocol ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol? { get set }
    
    var photos: [Photo] { get }
    
    func viewDidLoad()
    
    func updateTableViewAnimated()
    
    func fetchPhotosNextPage()
    
    func fetchPhotosIfNeed(forRowAt indexPath: IndexPath)
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, _ on: ImagesListCellDelegate)
    
    func prepareForSegue(for segue: UIStoryboardSegue, sender: Any?) 
    
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
