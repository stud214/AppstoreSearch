//
//  LookupTableViewController.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/10.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

enum LookupSectionType: Int {
    
    case summary = 0
    case ReleaseInfo
    case preview
    case description
    case appInfo
    
}

class LookupTableViewController: UITableViewController {
    
    var expandedIndexSet : [LookupSectionType] = []
    
    var viewModel: LookupItemViewModel? {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    var infoViewModel: [LookupAppInfoViewModel]? {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /**
     네비게이션바 아이콘과 다운로드 버튼 표시
     */
    fileprivate func updateNavigationBarView() {
        
        if self.navigationItem.titleView == nil {
            
            if let artworkUrl60 = self.viewModel?.icon, let url = URL(string: artworkUrl60) {
                
                let titleImgView = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
                titleImgView.backgroundColor = UIColor.clear
                titleImgView.image = nil
                titleImgView.layer.cornerRadius = 8.0
                titleImgView.clipsToBounds = true
                titleImgView.setImage(url, placeholder: nil, contentMode: .scaleAspectFit, cache: nil) { (result) in
                    
                }
                
                self.navigationItem.titleView = titleImgView
            }
            
            let button = UIButton(type: .custom)
            button.setTitle("열기", for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
            button.backgroundColor = UIColor.init(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0)
            button.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 24.0, bottom: 6.0, right: 24.0)
            button.layer.cornerRadius = 14.0
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
}

extension LookupTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let posY = scrollView.contentOffset.y
        let checkPosY: CGFloat = 110.0
        if posY <= checkPosY {
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = nil
        }
        if posY > checkPosY {
            self.updateNavigationBarView()
        }
    }
}

extension LookupTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = LookupSectionType(rawValue: section) {
            
            switch tableSection {
            case .summary, .ReleaseInfo, .preview, .description:
                return 1
            case .appInfo:
                return self.infoViewModel?.count ?? 0
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let section = LookupSectionType(rawValue: indexPath.section) {
            
            switch section {
                
            case .summary:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "LookupSummaryTableViewCell") as? LookupSummaryTableViewCell  {
                    cell.viewModel = self.viewModel
                    return cell
                }
                
            case .ReleaseInfo:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "LookupReleaseInfoTableViewCell") as? LookupReleaseInfoTableViewCell  {
                    cell.viewModel = self.viewModel
                    var isContain = false
                    
                    expandedIndexSet.forEach({ (type) in
                        guard type != section else {
                            isContain = true
                            return
                        }
                    })
                    
                    if isContain {
                        cell.releaseNoteLabel.numberOfLines = 0
                    }
                    
                    return cell
                }
                
            case .preview:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "LookupPreviewTableViewCell") as? LookupPreviewTableViewCell  {
                    cell.viewModel = self.viewModel
                    return cell
                }
                
            case .description:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier:
                    "LookupDescryptionTableViewCell") as? LookupDescryptionTableViewCell  {
                    
                    cell.viewModel = self.viewModel
                    var isContain = false
                    
                    expandedIndexSet.forEach({ (type) in
                        
                        guard type != section else {
                            isContain = true
                            return
                        }
                    })
                    
                    if isContain {
                        cell.descryptionLabel.numberOfLines = 0
                    }
                    
                    return cell
                }
            case .appInfo:
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "LookupAppInfoTableViewCell") as? LookupAppInfoTableViewCell  {
                    cell.viewModel = self.infoViewModel?[indexPath.row]
                    
                    return cell
                }
                
            }
            
        }
        return UITableViewCell()
    }
}

extension LookupTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        // if the cell is already expanded, remove it from the indexset to contract it
        
        if let section = LookupSectionType(rawValue: indexPath.section) {
            
            expandedIndexSet.forEach({ (type) in
                guard type != section else {
                    return
                }
            })
            
            switch section {
                
            case .ReleaseInfo, .description:
                expandedIndexSet.append(section)
                tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
            case .appInfo:
                let viewModel = self.infoViewModel?[indexPath.row]
                let useExpand = viewModel?.useExpand ?? false
                
                if let cell = tableView.cellForRow(at: indexPath) as? LookupAppInfoTableViewCell, useExpand == true {
                    
                    cell.openExpand()
                    self.infoViewModel?[indexPath.row].useExpand = false
                    self.infoViewModel?[indexPath.row].expandState = .expanded
                    UIView.setAnimationsEnabled(false)
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    UIView.setAnimationsEnabled(true)
                }
            default: break
                
            }
            
        }
    }
}
