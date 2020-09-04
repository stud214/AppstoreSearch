//
//  LookupPreviewTableViewCell.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/11.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class LookupPreviewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var screenshotUrls: [URL] = []
    
    var viewModel :LookupItemViewModel? {
        didSet {
            
            guard let item = viewModel else {
                return
            }
            
            if let screenshots = item.screenshot {
                for (_, screenshot) in screenshots.enumerated() {
                    
                    guard let screenshotUrl = URL(string: screenshot) else {
                        continue
                    }
                    screenshotUrls.append(screenshotUrl)
                }
                self.collectionView.reloadData()
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension LookupPreviewTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LookupPreviewImageCollectionViewCell", for: indexPath) as? LookupPreviewImageCollectionViewCell {
            cell.imageUrl = screenshotUrls[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}

extension LookupPreviewTableViewCell: UICollectionViewDelegate {
    
    //func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //}
    
}

extension LookupPreviewTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.size.width * 0.6
        let h = collectionView.frame.size.height 
        return CGSize(width: w - 5.0, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}
