//
//  SearchListTableViewCell.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/09.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class SearchListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var screenShotStackView: UIStackView!
    
    var iconImageUrl: String?
    var screenShotImageUrls: [URL] = []
    
    var screenshotImageViews: [UIImageView] {
        return screenShotStackView.arrangedSubviews as! [UIImageView]
    }
    
    fileprivate var screenshotUrls: [String] = []
    
    var viewModel :SearchItemViewModel? {
        didSet {
            
            guard let item = viewModel else {
                return
            }
            
            if let averageRating = item.averageRating {
                ratingView.rating = averageRating
            }
            
            titleLabel.text = item.title
            subTitleLabel.text = item.subTitle
            reviewCountLabel.text = item.ratingCount
            
            //아이콘 다운로드
            if let iconUrl = item.icon, let url = URL(string: iconUrl) {
                
                self.iconImageUrl = iconUrl
                
                appIconImageView.setImage(url, placeholder: nil, contentMode: .scaleAspectFit, cache: nil) { (result) in
                    
                }
            }
            
            if let screenshots = item.screenshot {
                
                for (index, screenshot) in screenshots.enumerated() {
                    
                    guard let screenshotUrl = URL(string: screenshot), index < 3 else {
                        return
                    }
                    
                    self.screenShotImageUrls.append(screenshotUrl)
                    
                    screenshotImageViews[index].setImage(screenshotUrl, placeholder: nil, contentMode: .scaleAspectFill, cache: nil) { [weak self] (result) in
                        
                        switch result {
                            
                        case .success(let image):
                            if image.size.width > image.size.height {
                                if index > 0 {
                                    self?.screenshotImageViews[index].isHidden = true
                                }
                            }
                        case .failure(_): break
                            
                        }
                        
                    }
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
        
        openButton.layer.cornerRadius = 10.0
        selectionStyle = .none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        for (_, imageView) in screenshotImageViews.enumerated() {
            imageView.isHidden = false
        }
    }
}

extension SearchListTableViewCell: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        print("didUpdate \(String(format: "%.2f", ratingView.rating))")
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        print("isUpdating \(String(format: "%.2f", ratingView.rating))")
    }
    
}


