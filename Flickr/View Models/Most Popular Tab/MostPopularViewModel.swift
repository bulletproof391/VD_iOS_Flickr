//
//  MostPopularViewModel.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 19.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation
import ReactiveSwift

class MostPopularViewModel {
    // MARK: - Public Properties
    let isUpdated: MutableProperty<Bool>
    var currentPage = 1
    
    // MARK: - Private Properties
    private let dataModel: InterestingnessModel
    private var cellViewModels: [MostPopularCellViewModel]
    
    // MARK: - Initializers
    init(with dataModel: InterestingnessModel) {
        self.dataModel = dataModel
        self.isUpdated = MutableProperty(Bool())
        self.cellViewModels = [MostPopularCellViewModel]()
        
        self.dataModel.photosList.signal.observeResult { [weak self] (photosListResult) in
            guard let weakSelf = self else { return }
            guard let photosList = photosListResult.value else { return }
            weakSelf.initializeCellViewModel(with: photosList)
            weakSelf.isUpdated.value = true
        }
    }
    
    
    // MARK: - Public Methods
    func mostPopularPhotos(page: Int) {
        currentPage = page
        dataModel.getInterestingness(page: page)
    }
    
    
    // MARK: - Collection View Data Source Delegate
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return dataModel.photosList.value.count
    }
    
    func cellForItemAt(_ indexPath: IndexPath) -> MostPopularCellViewModel {
        return cellViewModels[indexPath.item]
    }
    
    
    // MARK: - Private Methods
    func initializeCellViewModel(with photosList: [Photo]) {
        cellViewModels.removeAll()
        for item in photosList {
            let viewModel = MostPopularCellViewModel(item)
            cellViewModels.append(viewModel)
        }
    }
}
