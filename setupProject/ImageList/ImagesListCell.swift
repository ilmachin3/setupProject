//
//  ImagesListCell.swift
//  setupProject
//
//  Created by Илья Дышлюк on 08.03.2024.
//

import Foundation
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var sourceImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!

weak var delegate: ImagesListCellDelegate?

var photoId: String?

override func prepareForReuse() {
    super.prepareForReuse()
    sourceImageView.kf.cancelDownloadTask()
}

private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    dateLabel.textColor = .white
    return formatter
    
} ()

override func awakeFromNib() {
    super.awakeFromNib()
    heartButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
}

func configure(with photo: Photo) {
    self.photoId = photo.id
    
    sourceImageView.kf.indicatorType = .activity
    sourceImageView.kf.setImage(
        with: URL(string: photo.regularImageURL),
        placeholder: UIImage(named: "Stub"),
        options: [
            .transition(.fade(0.9)),
            .processor(DownsamplingImageProcessor(size: sourceImageView.bounds.size))
        ]
    )
    
    if let createdAt = photo.createdAt {
        dateLabel.text = dateFormatter.string(from: createdAt)
    } else {
        dateLabel.text = "Date not available"
    }
    
    let likeImage = photo.isLiked ? UIImage(named: "like_button_on"): UIImage(named: "like_button_off")
    heartButton.setImage(likeImage, for: .normal)
}


func updateLikeButton(isLiked: Bool) {
    let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
    heartButton.setImage(likeImage, for: .normal)
}

//Взаимодействие с сетью

@IBAction private func likeButtonPressed(_ sender: UIButton) {
    guard let currentImage = heartButton.image(for: .normal), let _ = self.photoId else {
        print("Error: photoId is nil")
        return
    }
    
    let isLiked = currentImage == UIImage(named: "like_button_on")
    let newImage = isLiked ? UIImage(named: "like_button_off") : UIImage(named: "like_button_on")
    heartButton.setImage(newImage, for: .normal)
    
    delegate?.imagesListCellDidTapLike(self)
}
}
