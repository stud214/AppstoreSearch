//
//  LookupSummaryTableViewCell.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/10.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class LookupSummaryTableViewCell: UITableViewCell, FloatRatingViewDelegate {
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var gradeLabel: UILabel!
    
    var viewModel :LookupItemViewModel? {
        
        didSet {
            
            guard let item = viewModel else {
                return
            }
            
            if let averageRating = item.averageRating {
                ratingView.rating = averageRating
                let rating = String(format: "%.1f", Double(round(1000 * averageRating)/1000))
                gradeLabel.text = rating
            }
            
            titleLabel.text = item.title
            subTitleLabel.text = item.subTitle
            reviewCountLabel.text = item.ratingCount
            
            //아이콘 다운로드
            if let iconUrl = item.icon, let url = URL(string: iconUrl) {
                
                appIconImageView.setImage(url, placeholder: nil, contentMode: .scaleAspectFit, cache: nil) { (result) in
                    
                }
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.backgroundColor = UIColor.clear
        ratingView.delegate = self
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        ratingView.type = .floatRatings
        ratingView.editable = false
        
        appIconImageView.clipsToBounds = true
        appIconImageView.layer.cornerRadius = 10.0
        
        openButton.layer.cornerRadius = 14.0
        selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
