//
//  LookupPreviewImageCollectionViewCell.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/11.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class LookupPreviewImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    var imageUrl: URL? {
            didSet {
                
                guard let url = imageUrl else {
                    return
                }
                
                self.previewImageView.setImage(url, placeholder: nil, contentMode: .scaleAspectFill, cache: nil) { (reulst) in
                    
                }
                
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        previewImageView.clipsToBounds = true
        previewImageView.layer.cornerRadius = 10.0
    }
}
