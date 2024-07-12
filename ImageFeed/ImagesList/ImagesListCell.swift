//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Дмитрий Матвеев on 11.07.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}
