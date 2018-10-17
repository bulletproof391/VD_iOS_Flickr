//
//  CommonTableViewCell.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 16.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class CommonTableViewCell: UITableViewCell {
    // MARK: - UI Elements
    @IBOutlet var cameraImage: UIImageView!
    @IBOutlet var title: UILabel!
    
    // MARK: - Public Properties
    let viewModel = MutableProperty(CommonCellViewModel())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private Methods
    private func initializeView() {
        title.reactive.text <~ viewModel.map { $0.title }
        cameraImage.reactive.image <~ viewModel.producer.flatMap(.latest) { cellViewModel in
            cellViewModel.getImage().map(Optional.some).prefix(value: nil)
        }
    }
}
