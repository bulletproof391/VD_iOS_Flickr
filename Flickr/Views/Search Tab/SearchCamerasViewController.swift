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
    
    // MARK: - Public Properties
    var viewModel: SearchCamerasViewModel!
    
    // MARK: - Private Properties
    private let searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configuring Search Bar
        setUpSearchBar()
        // Configuring Table View
        setUpTableView()
        // Update View Controller
        updateViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // start searching
        guard let searchingString = searchBar.text else {
            fatalError("No valid string was submitted")
        }
        
        viewModel.searchCameras(of: searchingString)
    }
    
    
    // MARK: - Table View Data Source Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cellForRowAt(indexPath)
        var cell: UITableViewCell
        
        switch cellViewModel.cellReuseIdentifier {
        case CellReuseIdentifier.detail.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier, for: indexPath) as! DetailTableViewCell
            (cell as! DetailTableViewCell).viewModel.value = cellViewModel as! DetailCellViewModel
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier, for: indexPath) as! CommonTableViewCell
            (cell as! CommonTableViewCell).viewModel.value = cellViewModel as! CommonCellViewModel
        }
        
        return cell
    }
    
    
    // MARK: - Private Methods
    private func setUpSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search cameras"
        searchBar.delegate = self
        
        navigationBar.topItem?.titleView = searchBar
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    private func updateViewController() {
        viewModel.isUpdated.signal.observeResult { [weak self] (result) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
            }
        }
    }
}

