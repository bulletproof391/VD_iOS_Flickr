//
//  CamerasModel.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 15.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation
import ReactiveSwift

class CamerasModel {
    // MARK: - Public Properties
    let camerasList = MutableProperty([Camera]())
    
    // MARK: - Private Properties
    private let flickrAPI = Flickr()
    
    // MARK: - Public Methods
    func getCameras(of brand: String) {
        flickrAPI.camerasGetBrandModels(brand: brand) { [weak self] (camerasData) in
            do {
                guard let weakSelf = self else { return }
                guard let data = camerasData else { return }
                // Parsing JSON
                let result = try JSONDecoder().decode(CamerasGetBrandModelsResponse.self, from: data)

                if let cameras = result.cameras, let camerasList = cameras.camera {
                    weakSelf.camerasList.value = camerasList
                } else {
                    weakSelf.camerasList.value.removeAll()
                }

            } catch let jsonErr {
                print("JSON serialization error:", jsonErr)
            }
        }
    }
    
//    func getInterestingness(page: Int) {
//        flickrAPI.interestingnessGetList(page: 1) { [weak self] (interestingness) in
//            do {
//                guard let weakSelf = self else { return }
//                guard let data = interestingness else { return }
//                // Parsing JSON
//                let result = try JSONDecoder().decode(InterestingnessResponse.self, from: data)
//
//                if let photos = result.photos, let photosList = photos.photo {
//                    for item in photosList {
//
//                    }
//                    //                    completionHandler(goods)
//                    //
//                    //                    if page == 0 {
//                    //                        weakSelf.offset = goods.count
//                    //                        if goods.count > 0 {
//                    //                            weakSelf.lastPage = total / weakSelf.offset + 1
//                    //                        }
//                    //                    }
//                }
//
//            } catch let jsonErr {
//                print("JSON serialization error:", jsonErr)
//            }
//        }
//    }
}
