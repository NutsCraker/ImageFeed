//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alexander Farizanov on 29.01.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var dateTextLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewCell.kf.cancelDownloadTask()
    }
    
    func setLike(like: Bool) {
        if like {
            likeButton.setImage(UIImage(named: "Active"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
}
