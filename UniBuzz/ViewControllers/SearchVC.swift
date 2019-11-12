//
//  SearchVC.swift
//  Unibuzz
//
//  Created by kh on 9/1/19.
//  Copyright © 2019 jonh. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let baseHeight: CGFloat = 202
    
    var allData: [String] = ["Arabia", "US", "UK", "Saudi Arabia"]
    var candidates: [String] = ["Arabia", "US", "UK", "Saudi Arabia"]
    
    var searchTitle: String = "Item"
    var finished: ((Int)->())?
    
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var searchListTable: UITableView!
    @IBOutlet weak var searchListTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        candidates = allData
        txtTitle.text = "Select " + searchTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchListCell", for: indexPath) as! SearchListCell
        cell.setItem(item: candidates[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let index = allData.index(of: candidates[indexPath.row]) {
            finished?(index)
        }
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                let height = tableView.contentSize.height
                if(height + baseHeight > view.frame.height - 60) {
                    heightConstraint.constant = view.frame.height - 60
                    tableView.isScrollEnabled = true
                } else {
                    heightConstraint.constant = height + baseHeight
                    tableView.isScrollEnabled = false
                }
            }
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(filter: searchText)
        searchListTable.reloadData()
    }
    
    func filter(filter: String) {
        candidates = []
        if( filter == "") {
            candidates = allData
            return
        }
        let stringArray = allData.filter { $0.lowercased().contains(filter.lowercased())}
        candidates.append(contentsOf: stringArray)
    }
}

