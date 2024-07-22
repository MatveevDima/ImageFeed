//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 21.07.2024.
//

import UIKit

protocol ImagesListViewControllerProtocol : AnyObject  {
    
    func setRowHeight(_ newValue: CGFloat)
    
    func setContentInset(_ newValue: UIEdgeInsets)
    
    func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)
    
    func insertRow(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) 
    
    func getIndexPathForCell(_ cell: ImagesListCell) -> IndexPath? 
}
