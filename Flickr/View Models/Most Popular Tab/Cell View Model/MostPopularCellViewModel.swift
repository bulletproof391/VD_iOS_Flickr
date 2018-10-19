//
//  MostPopularCellViewModel.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 19.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

enum CollectionCellReuseIdentifier: String {
    case common = "Cell"
}

class MostPopularCellViewModel {
    // MARK: - Public Properties
    var image: UIImage?
    var cellReuseIdentifier: String
    
    // MARK: - Private Proerties
    internal var imageURL: String?
    
    // MARK: - Initializers
    init() {
        self.cellReuseIdentifier = CollectionCellReuseIdentifier.common.rawValue
    }
    init(_ photo: Photo) {
        self.imageURL = photo.url_s
        self.cellReuseIdentifier = CollectionCellReuseIdentifier.common.rawValue
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
                } else {
                    observer.send(value: #imageLiteral(resourceName: "no image"))
                    self!.image = #imageLiteral(resourceName: "no image")
                }
            }
        }
    }
}
