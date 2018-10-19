//
//  MostPopularCollectionViewCell.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 19.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class MostPopularCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    @IBOutlet var image: UIImageView!
    
    // MARK: - Public Properties
    let viewModel = MutableProperty(MostPopularCellViewModel())
    
    // MARK: - Public Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeView()
    }
    
    // MARK: - Private Methods
    private func initializeView() {
        image.reactive.image <~ viewModel.producer.flatMap(.latest) { cellViewModel in
            cellViewModel.getImage().map(Optional.some).prefix(value: nil)
        }
    }
}
