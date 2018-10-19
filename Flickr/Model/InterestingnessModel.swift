//
//  InterestingnessModel.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 19.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation
import ReactiveSwift

class InterestingnessModel {
    // MARK: - Public Properties
    let photosList = MutableProperty([Photo]())
    var page = 1
    var pages = 0
    var itemsPerPage = 10
    
    // MARK: - Private Properties
    private let flickrAPI = Flickr()
    
    // MARK: - Public Methods
    func getInterestingness(page: Int) {
        flickrAPI.interestingnessGetList(page: page) { [weak self] (interestingness) in
            do {
                guard let weakSelf = self else { return }
                guard let data = interestingness else { return }
                
                // Parsing JSON
                let result = try JSONDecoder().decode(InterestingnessResponse.self, from: data)

                if let photos = result.photos, let photosList = photos.photo {
                    weakSelf.page = page
                    if page == 1, let newPages = photos.pages, let newPerPage = photos.perpage {
                        weakSelf.pages = newPages
                        weakSelf.itemsPerPage = newPerPage
                    }
                                        
                    weakSelf.photosList.value = photosList
                } else {
                    weakSelf.photosList.value.removeAll()
                }

            } catch let jsonErr {
                print("JSON serialization error:", jsonErr)
            }
        }
    }
}
