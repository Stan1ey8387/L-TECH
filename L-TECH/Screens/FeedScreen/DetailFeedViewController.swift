//
//  DetailFeedViewController.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import UIKit
import Kingfisher

class DetailFeedViewController: UIViewController {
    
    
    // Variables
    
    var feedElement: FeedElement?
    
    
    //MARK: Outlets
    
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var detailTitleLabel: UILabel!
    

    //MARK: View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurate()
    }
    
    
    //MARK: Methods
    
    private func configurate() {
        if let feedElement = feedElement {
            title = feedElement.title
            titleLabel.text = feedElement.title
            detailTitleLabel.text = feedElement.text
            
            if let link = feedElement.image, let url = URL(string: link) {
                photoImageView.kf.indicatorType = .activity
                photoImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Image_empty"))
            }
        } else {
            showAlert("Error", message: nil, titleAction: "OK", cancelAction: false, handler: { [weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }
}
