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
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UITableViewCell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Public Methods
    
    func setIsLiked(isLiked: Bool) {
        let likeIndicatorImage = isLiked ? UIImage(named: "Active Like") : UIImage(named: "No Active Like")
        likeButton.setImage(likeIndicatorImage, for: .normal)
    }
    
    // MARK: - IBAction
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
