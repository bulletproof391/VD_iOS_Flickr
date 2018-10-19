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
    private let acitivityIndicator = UIActivityIndicatorView()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configuring Search Bar
        setUpSearchBar()
        // Configuring Table View
        setUpTableView()
        // Configuring Activity Indicator
        setUpActivityIndicator()
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
        
        acitivityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
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
                weakSelf.acitivityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                weakSelf.nothingIsFound()
                weakSelf.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    private func nothingIsFound() {
        if viewModel.numberOfRowsInSection(0) == 0 {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView!.bounds.size.width, height: tableView!.bounds.size.height))
            noDataLabel.text = "Nothing is found"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            
            tableView!.backgroundView = noDataLabel
            tableView!.separatorStyle = .none
        } else {
            tableView!.backgroundView = nil
            tableView!.separatorStyle = .singleLine
        }
    }
    
    private func setUpActivityIndicator() {
        acitivityIndicator.center = view.center
        acitivityIndicator.hidesWhenStopped = true
        acitivityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(acitivityIndicator)
    }
}

