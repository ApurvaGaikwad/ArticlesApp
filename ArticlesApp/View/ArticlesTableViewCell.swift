

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDesignationLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var articleContentLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleUrlLabel: UILabel!
    @IBOutlet weak var totalLikesLabel: UILabel!
    @IBOutlet weak var totalCommentLabel: UILabel!
    @IBOutlet weak var mediaImageHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var totalLikesCommentsLabel: UILabel!
    
    var article: Article? {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
            
            //compression resistense
            articleTitleLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
            articleUrlLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
            guard let articleItem = article else { return }
            var userName = ""
            if let user = articleItem.user?.first {
                if let userImage = user.avatar {
                    downloadImage(imageUrl: userImage, imageType: .UserImage)
                }
                if let userDesignation = user.designation {
                    userDesignationLabel.text = userDesignation
                }
                if let firstName = user.name {
                    userName = firstName
                    if let lastName = user.lastname {
                        userNameLabel.text = userName + " " + lastName
                    } else {
                        userNameLabel.text = userName
                    }
                }
            }
            
            if let articleContent = articleItem.content {
                articleContentLabel.text = articleContent
            }
            
            if let articleComment = articleItem.comments {
                totalCommentLabel.text = "\(articleComment)"
            }
            
            if let articleLikes = articleItem.likes {
                totalLikesLabel.text = "\(articleLikes)"
            }
            
            if let articleMedia = articleItem.media?.first {
                if let mediaImageUrl = articleMedia.image {
                    downloadImage(imageUrl: mediaImageUrl, imageType: .MediaImage)
                }
                if let articleTitle = articleMedia.title {
                    articleTitleLabel.text = articleTitle
                }
                if let articleUrl = articleMedia.url {
                    articleUrlLabel.text = articleUrl
                }
            }
        }
        
    }
    
    enum ImageType {
        case UserImage
        case MediaImage
    }
    
    private func downloadImage(imageUrl: String, imageType: ImageType) {
        DispatchQueue.global().async {
            //download the image here
            if let url = URL(string: imageUrl),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    switch imageType {
                    case .UserImage:
                        self.userImageView.image = nil
                        self.userImageView.image = image
                    case .MediaImage:
                        self.mediaImageView.image = nil
                        self.mediaImageView.image = image
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.mediaImageHeightConstraints.constant = 0
                }
            }
        }
    }
}
