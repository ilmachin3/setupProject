//
//  ImagesListCell.swift
//  setupProject
//
//  Created by Илья Дышлюк on 08.03.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var zeroImage: UIImageView!
    
    @IBOutlet weak var underAdress: UILabel!
}
