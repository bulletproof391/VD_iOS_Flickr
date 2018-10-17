//
//  DetailCellViewModel.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 16.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit

final class DetailCellViewModel: CellViewModel {
    // MARK: - Public Properties
    var megapixels: String?
    var screenSize: String?
    var memoryType: String?
    
    // MARK: - Initializers
    override init(_ camera: Camera) {
        super.init(camera)
        
        self.imageURL = camera.images?.large?._content
        self.megapixels = camera.details?.megapixels?._content != nil ? camera.details?.megapixels?._content : "N/A"
        self.screenSize = camera.details?.lcd_screen_size?._content != nil ? camera.details?.lcd_screen_size?._content : "N/A"
        self.memoryType = camera.details?.memory_type?._content != nil ? camera.details?.memory_type?._content : "N/A"
        self.cellReuseIdentifier = CellReuseIdentifier.detail.rawValue
    }
    
    override init() {
        super.init()
        self.cellReuseIdentifier = CellReuseIdentifier.detail.rawValue
    }
}
