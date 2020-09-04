//
//  SearchMainTableViewController.swift
//  AppStoreSearch
//
//  Created by Hyun BnS on 2020/08/08.
//  Copyright © 2020 Hyun BnS. All rights reserved.
//

import UIKit

class SearchMainTableViewController: UITableViewController {
    
    @IBOutlet weak var recentTitle: UILabel!
    @IBOutlet weak var recentHeaderView: UIView!
    var viewModel = SearchViewModel()
    var lookupViewModel = LookupViewModel()
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "App Store"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigationItem()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        self.searchController.searchBar.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.searchTextField.delegate = self
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension SearchMainTableViewController {
    
    private func makeNavigationItem() {
        
        navigationItem.title = "검색"
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
    }
    
    private func filterContentForSearchKeyWord(_ searchKeyword: String) {
        
        viewModel.searchType = .local
        viewModel.term = searchKeyword
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    private func searchKeyword(_ searchKeyword: String) {
        
        viewModel.searchType = .server
        viewModel.term = searchKeyword
        viewModel.handler = {[weak self] (status) in
            
            DispatchQueue.main.async {
                self?.searchController.isActive = true
                self?.searchController.searchBar.text = searchKeyword
                self?.tableView.reloadData()
            }
        }
    }
    
    private func cancel() {
        viewModel = SearchViewModel()
        DispatchQueue.main.async {
            
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.searchController.searchBar.showsCancelButton  = false
            let indexPath = NSIndexPath(row: NSNotFound, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
            self.tableView.reloadData()
            
        }
    }
    
    private func deSelectedRow() {
        
        if let index = tableView.indexPathForSelectedRow {
            
            self.tableView.deselectRow(at: index, animated: true)
        }
        
    }
    
}

extension SearchMainTableViewController {
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        
        if searchController.isActive {
            
            if self.viewModel.searchType == .local {
                return self.viewModel.autoCompleteList.count
            }
            
            return self.viewModel.searchList.count
        }
        return self.viewModel.searchType == .local ? self.viewModel.keywordList.count: self.viewModel.searchList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.searchType == .local {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMainTableViewCell", for: indexPath) as? SearchMainTableViewCell {
                //cell.accessoryType = .disclosureIndicator
                var cellData :[String] = []
                if searchController.isActive {
                    
                    guard let term = self.viewModel.term else {
                        return cell
                    }
                    
                    cellData = viewModel.autoCompleteList
                    cell.grassImageView.isHidden = false
                    cell.keywordLabel.changePartColor(fullText: cellData[indexPath.row], changeText: term)
                    
                } else {
                    
                    cell.grassImageView.isHidden = true
                    cellData = viewModel.keywordList
                    cell.keywordLabel.text = cellData[indexPath.row]
                }
                
                /*if !searchController.isActive, indexPath.row == cellData.count - 1 {
                 cell.hideSeparator()
                 }*/
                
                return cell
                
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListTableViewCell", for: indexPath) as? SearchListTableViewCell {
                
                cell.viewModel = self.viewModel.searchList[indexPath.row]
                cell.hideSeparator()
                return cell
            }
        }
        
        
        
        return UITableViewCell()
    }
}

extension SearchMainTableViewController {
    
    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = tableView.cellForRow(at: indexPath) as? SearchMainTableViewCell {
            
            var searchKeyword = ""
            if searchController.isActive && viewModel.searchType == .local {
                searchKeyword = viewModel.autoCompleteList[indexPath.row]
            } else {
                searchKeyword = viewModel.keywordList[indexPath.row]
            }
            
            self.searchKeyword(searchKeyword)
            
        } else if let _ = tableView.cellForRow(at: indexPath) as? SearchListTableViewCell {
            
            lookupViewModel.bundleId = viewModel.searchList[indexPath.row].bundleId
            
            lookupViewModel.handler = {[weak self] (status) in
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    if let controller = storyboard.instantiateViewController(withIdentifier: "LookupTableViewController") as? LookupTableViewController {
                        controller.viewModel = self?.lookupViewModel.lookupList.first
                        controller.infoViewModel = self?.lookupViewModel.lookupList.first?.makeAppInfoViewModel()
                        self?.navigationController?.pushViewController(controller, animated: true)
                    }
                    
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if let cell = cell as? SearchListTableViewCell {
//            
//            for (index, imageView) in cell.screenshotImageViews.enumerated() {
//                
//                guard let image = imageView.image, image.size.width > image.size.height else {
//                    return
//                }
//                
//                if index > 0 {
//                    imageView.isHidden = true
//                }
//            }
//        }
        
        self.cellHeights[indexPath] = cell.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.cellHeights[indexPath] {
            return height
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.addSubview(recentHeaderView)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if searchController.isActive || viewModel.searchType == .server {
            return 0
        }
        
        return recentHeaderView.frame.height
    }
}

extension SearchMainTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKeyword = searchController.searchBar.text else {
            return
        }
        self.searchKeyword(searchKeyword)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancel()
    }
}

extension SearchMainTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchController.searchBar.showsCancelButton = true
        guard let searchKeyword = searchController.searchBar.text, viewModel.searchType == .local else {
            return
        }
        
        self.filterContentForSearchKeyWord(searchKeyword)
    }
}

extension SearchMainTableViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        self.searchKeyword("")
        return true
        
    }
}

