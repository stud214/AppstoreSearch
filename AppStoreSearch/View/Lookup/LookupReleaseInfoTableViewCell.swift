//
//  LookupReleaseInfoTableViewCell.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/11.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class LookupReleaseInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var newFuntionLabel: UILabel!
    @IBOutlet weak var releaseVersionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var releaseNoteLabel: UILabel!
    
    var viewModel :LookupItemViewModel? {
        didSet {
            guard let item = viewModel else {
                return
            }
            releaseVersionLabel.text = "버전 \(item.version ?? "")"
            releaseNoteLabel.text = item.releaseDescryption
            
            let date = Date.convertAppleStringToDate(item.releaseDate)
            dateLabel.text = Date.timeAgoSince(date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        releaseNoteLabel.numberOfLines = 5
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
