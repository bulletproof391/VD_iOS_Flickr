//
//  FirstViewController.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 14.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit

class SearchCamerasViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    // MARK: - UI Elements
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Private Properties
    private let detailCellReuseIdentifier = "DetailCell"
    private let commonCellReuseIdentifier = "CommonCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configuring Search Bar
        setUpSearchBar()
        // Configuring Table View
        setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View Data Source Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if indexPath.row == 0 || indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: detailCellReuseIdentifier, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: commonCellReuseIdentifier, for: indexPath)
        }
        
        return cell
    }
    
    
    // MARK: - Private Methods
    private func setUpSearchBar() {
        let searchBar = UISearchBar()
        
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search cameras"
        searchBar.delegate = self
        
        navigationBar.topItem?.titleView = searchBar
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
    }
}

