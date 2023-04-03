import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
   // override var preferredStatusBarStyle: UIStatusBarStyle {
   //     return .lightContent
   // }
    
    override func prepareForReuse() {
           super.prepareForReuse()
           imageCell.kf.cancelDownloadTask()
       }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
   
    func setLike(like: Bool) {
            if like {
                likeButton.setImage(UIImage(named: "liked"), for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "notLiked"), for: .normal)
            }
        }
}
