//
//  FeedTableViewCell.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import UIKit
import Kingfisher

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configurate(_ feedElement: FeedElement) {
        titleLabel.text = feedElement.title
        detailTitleLabel.text = feedElement.text
        dateLabel.text = feedElement.date
        
        if let link = feedElement.image, let url = URL(string: link) {
            photoImageView.kf.indicatorType = .activity
            photoImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Image_empty"))
        }
    }
}
