//
//  SearchMainTableViewCell.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/08.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class SearchMainTableViewCell: UITableViewCell {

    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var grassImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.clearAttributes()
    }
    
    func clearAttributes () {
        keywordLabel.font = UIFont.systemFont(ofSize: 18)
        keywordLabel.textColor =  UIColor(displayP3Red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    }
}

extension UILabel {
    
    func changePartColor(fullText: String , changeText: String) {
        
        self.textColor = UIColor(white: 0.56, alpha: 1.0)
        let size = self.font.pointSize
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold) , range: range)
        self.attributedText = attribute
        
    }
    
}

extension UITableViewCell {

  func hideSeparator() {
    self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
  }

  func showSeparator() {
    self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}
