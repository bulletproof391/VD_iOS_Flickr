//
//  FlickrResponses.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 15.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation

struct CamerasGetBrandModelsResponse: Decodable {
    var cameras: CamerasResponse?
    var stat: String?
}

struct CamerasResponse: Decodable {
    var brand: String?
    var camera: [Camera]?
}

struct Camera: Decodable {
    var id: String?
    var name: Content?
    var images: ImagesContent?
    var details: Details?
}

struct ImagesContent: Decodable {
    var small: Content?
    var large: Content?
}

struct Details: Decodable {
    var megapixels: Content?
    var lcd_screen_size: Content?
    var memory_type: Content?
}

struct Content: Decodable {
    var _content: String?
}




struct InterestingnessResponse: Decodable {
    var photos: PhotosResponse?
    var stat: String?
}

struct PhotosResponse: Decodable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: Int?
    var photo: [Photo]?
}

struct Photo: Decodable {
    var id: String?
    var title: String?
    var url_s: String?
}
