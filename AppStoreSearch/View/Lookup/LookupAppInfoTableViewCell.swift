//
//  LookupAppInfoTableViewCell.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/11.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class LookupAppInfoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var arrowImgView: UIImageView!
    
    @IBOutlet private weak var arrowRightConstraint: NSLayoutConstraint!
    
    private let expandedViewIndex: Int = 1
    private var defaultArrowRightConstraintValue: CGFloat = 0.0
    
    var viewModel: LookupAppInfoViewModel? {
        
        didSet {
            let title = viewModel?.title ?? ""
            let subtitle = viewModel?.subtitle ?? ""
            let desc = viewModel?.desc ?? ""
            let useExpand = viewModel?.useExpand ?? false
            let expandState = viewModel?.expandState ?? .collapsed
            
            titleLabel.text = title
            subTitleLabel.text = subtitle
            descriptionLabel.text = desc
            
            self.stackView.arrangedSubviews[expandedViewIndex].isHidden = (expandState == .collapsed) ? true : false
            
            self.arrowImgView.isHidden = useExpand ? false : true
            self.arrowRightConstraint.constant = useExpand ? 22 : 0
        }
    }
    
    public func openExpand() {

        //self.stackView.arrangedSubviews[expandedViewIndex].isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: {
            self.subTitleLabel.alpha = 0.0
            self.arrowImgView.alpha = 0.0
        }) { (finished) in
            if finished {
                self.subTitleLabel.isHidden = true
                self.arrowImgView.isHidden = true
            }
        }
    }
    
    private func updateArrowImageHidden(_ hidden: Bool) {
        arrowImgView.isHidden = hidden
        arrowRightConstraint.constant = hidden ? 0 : 35
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
}
