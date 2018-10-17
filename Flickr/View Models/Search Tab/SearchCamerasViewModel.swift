//
//  SearchCamerasViewModel.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 15.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation
import ReactiveSwift

class SearchCamerasViewModel {
    // MARK: - Public Properties
    let isUpdated: MutableProperty<Bool>
    
    // MARK: - Private Properties
    private let dataModel: CamerasModel
    private var cellViewModels: [CellViewModel]
    
    // MARK: - Initializers
    init(with dataModel: CamerasModel) {
        self.dataModel = dataModel
        self.isUpdated = MutableProperty(Bool())
        self.cellViewModels = [CellViewModel]()
        
        self.dataModel.camerasList.signal.observeResult { [weak self] (camerasListResult) in
            guard let weakSelf = self else { return }
            guard let camerasList = camerasListResult.value else { return }
            weakSelf.initializeCellViewModel(with: camerasList)
            weakSelf.isUpdated.value = true
        }
    }
    
    // MARK: - Public Methods
    func searchCameras(of brand: String) {
        dataModel.getCameras(of: brand)
    }
    
    // MARK: - Table View Data Source Delegate
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return dataModel.camerasList.value.count
    }
    
    func cellForRowAt(_ indexPath: IndexPath) -> CellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    // MARK: - Private Methods
    func initializeCellViewModel(with camerasList: [Camera]) {
        cellViewModels.removeAll()
        for item in camerasList {
            var viewModel: CellViewModel
            if let _ = item.details {
                viewModel = DetailCellViewModel(item)
            } else {
                viewModel = CommonCellViewModel(item)
            }
            cellViewModels.append(viewModel)
        }
    }
}
