//
//  SecondViewController.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 14.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit

enum CollectionViewLayout: CGFloat {
    case interitemSpacing = 5
    case numberOfItems = 2
}

class MostPopularViewController: UIViewController, UICollectionViewDataSource {
    // MARK: - UI Elements
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var currentPage: UILabel!
    @IBOutlet var previousButton: UIBarButtonItem!
    @IBOutlet var nextButton: UIBarButtonItem!
    
    // MARK: - Public Properties
    var viewModel: MostPopularViewModel!
    
    // MARK: - Private Properties
    private let acitivityIndicator = UIActivityIndicatorView()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configuring Collection View
        setUpCollectionView()
        // Configuring Activity Indicator
        setUpActivityIndicator()
        // Configuring Buttons
        setUpButtons()
        // Update View Controller
        updateViewController()
        
        mostPopularPhotos(page: viewModel.currentPage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Button Actions
    @IBAction func previousPage(_ sender: Any) {
        viewModel.currentPage -= 1
        mostPopularPhotos(page: viewModel.currentPage)
    }
    @IBAction func nextPage(_ sender: Any) {
        viewModel.currentPage += 1
        mostPopularPhotos(page: viewModel.currentPage)
    }
    
    
    // MARK: - Collection View Data Source Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.cellForItemAt(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.cellReuseIdentifier, for: indexPath) as! MostPopularCollectionViewCell
        cell.viewModel.value = cellViewModel
        
        return cell
    }
    
    //MARK: - Private Methods
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.allowsSelection = false
        
        setUpCollectionViewLayout()
    }
    
    func setUpCollectionViewLayout() {
        let interitemSpacing = CollectionViewLayout.interitemSpacing.rawValue
        let itemSize = (UIScreen.main.bounds.width - interitemSpacing) / CollectionViewLayout.numberOfItems.rawValue
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = interitemSpacing
        
        collectionView?.collectionViewLayout = layout
    }
    
    private func updateViewController() {
        viewModel.isUpdated.signal.observeResult { [weak self] (result) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.acitivityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                weakSelf.setUpButtons()
                weakSelf.nothingIsFound()
                if weakSelf.viewModel.numberOfItemsInSection(0) > 0 {
                    weakSelf.currentPage.text = "\(weakSelf.viewModel.currentPage) of \(weakSelf.viewModel.totalPages)"
                } else {
                    weakSelf.currentPage.text = ""
                }
                weakSelf.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
    private func setUpActivityIndicator() {
        acitivityIndicator.center = view.center
        acitivityIndicator.hidesWhenStopped = true
        acitivityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(acitivityIndicator)
    }
    
    private func mostPopularPhotos(page: Int) {
        acitivityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        viewModel.mostPopularPhotos(page: page)
    }
    
    private func setUpButtons() {
        previousButton.isEnabled = true
        nextButton.isEnabled = true
        
        if viewModel.currentPage == 1 {
            previousButton.isEnabled = false
        }
        
        if viewModel.currentPage == viewModel.totalPages {
            nextButton.isEnabled = false
        }
    }
    
    private func nothingIsFound() {
        if viewModel.numberOfItemsInSection(0) == 0 {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height))
            noDataLabel.text = "Nothing is found"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            
            collectionView!.backgroundView = noDataLabel
        } else {
            collectionView!.backgroundView = nil
        }
    }
}

