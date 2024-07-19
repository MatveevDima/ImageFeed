//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 19.07.2024.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
