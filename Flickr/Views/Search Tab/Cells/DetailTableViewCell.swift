//
//  DetailTableViewCell.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 16.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class DetailTableViewCell: UITableViewCell {
    // MARK: - UI Elements
    @IBOutlet var cameraImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var megapixels: UILabel!
    @IBOutlet var screenSize: UILabel!
    @IBOutlet var memoryType: UILabel!
    
    // MARK: - Public Properties
    let viewModel = MutableProperty(DetailCellViewModel())
    
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
        megapixels.reactive.text <~ viewModel.map { $0.megapixels }
        screenSize.reactive.text <~ viewModel.map{ $0.screenSize }
        memoryType.reactive.text <~ viewModel.map{ $0.memoryType }
        
        cameraImage.reactive.image <~ viewModel.producer.flatMap(.latest) { cellViewModel in
            cellViewModel.getImage().map(Optional.some).prefix(value: nil)
        }
    }
}
