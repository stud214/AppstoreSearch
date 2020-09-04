//
//  LookupAppInfoTableViewCell.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/11.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class LookupDescryptionTableViewCell: UITableViewCell {
    @IBOutlet weak var descryptionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    
    var viewModel :LookupItemViewModel? {
        didSet {
            
            guard let item = viewModel else {
                return
            }
            
            descryptionLabel.text = item.descryption
            companyLabel.text = item.sellerName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descryptionLabel.numberOfLines = 5
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
