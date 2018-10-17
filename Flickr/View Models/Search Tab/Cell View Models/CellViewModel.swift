//
//  CellViewModel.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 16.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

enum CellReuseIdentifier: String {
    case detail = "DetailCell"
    case common = "CommonCell"
}

class CellViewModel {
    // MARK: - Public Properties
    var title: String?
    var image: UIImage?
    var cellReuseIdentifier: String
    
    // MARK: - Internal Proerties
    internal var imageURL: String?
    
    // MARK: - Initializers
    init() {
        self.title = nil
        self.image = nil
        self.cellReuseIdentifier = CellReuseIdentifier.common.rawValue
    }
    init(_ camera: Camera) {
        self.title = camera.name?._content
        self.imageURL = camera.images?.small?._content
        self.cellReuseIdentifier = CellReuseIdentifier.common.rawValue
    }
    
    // MARK: - Public Methods
    func getImage() -> SignalProducer<UIImage, NoError> {
        return SignalProducer<UIImage, NoError> { [weak self] observer, _ in
            if let _ = self!.image {
                observer.send(value: self!.image!)
            } else {
                if let urlString = self!.imageURL, let newUrl = URL(string: urlString) {
                    URLSession.shared.dataTask(with: newUrl) { [weak self] (data, urlRsponse, err) in
                        if let receivedData = data, let weakSelf = self, let receivedImage = UIImage(data: receivedData) {
                            observer.send(value: receivedImage)
                            weakSelf.image = receivedImage
                        }
                        }.resume()
                }
            }
        }
    }
    
}
