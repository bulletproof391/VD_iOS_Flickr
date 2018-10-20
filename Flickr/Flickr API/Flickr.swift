//
//  Flickr.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 15.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation

fileprivate let apiKey = "6bd5f547fb7f91b63bf56ebecc2b59dc"
fileprivate let itemsPerPage = 10

enum FlickrAPI: String {
    case host = "api.flickr.com"
    case scheme = "https"
    case services = "/services/rest"
    case method = "method"
    case format = "format"
    case date = "date"
    case extras = "extras"
    case perPage = "per_page"
    case page = "page"
    case nojsoncallback = "nojsoncallback"
    case apiKey = "api_key"
    case brand = "brand"
}

enum FlickrAPIParameters: String {
    case brandModels = "flickr.cameras.getBrandModels"
    case interestingness = "flickr.interestingness.getList"
    case json = "json"
    case url_s = "url_s"
}

class Flickr {
    // MARK: - Public Methods
    func camerasGetBrandModels(brand: String, completionHandler: @escaping (Data?) -> Void) {
        var components = initializeURLComponents()
        
        let queryMethod = URLQueryItem(name: FlickrAPI.method.rawValue, value: FlickrAPIParameters.brandModels.rawValue)
        let queryFormat = URLQueryItem(name: FlickrAPI.format.rawValue, value: FlickrAPIParameters.json.rawValue)
        let queryNoJSONCallBack = URLQueryItem(name: FlickrAPI.nojsoncallback.rawValue, value: String(1))
        let queryAPIKey = URLQueryItem(name: FlickrAPI.apiKey.rawValue, value: apiKey)
        let queryBrand = URLQueryItem(name: FlickrAPI.brand.rawValue, value: brand)
        
        components.queryItems = [queryMethod, queryFormat, queryNoJSONCallBack, queryAPIKey, queryBrand]
        
        if let url = components.url {
            performURLRequestWith(url, completionHandler: completionHandler)
        }
    }
    
    func interestingnessGetList(page: Int, completionHandler: @escaping (Data?) -> Void) {
        var components = initializeURLComponents()
        
        let queryMethod = URLQueryItem(name: FlickrAPI.method.rawValue, value: FlickrAPIParameters.interestingness.rawValue)
        let queryAPIKey = URLQueryItem(name: FlickrAPI.apiKey.rawValue, value: apiKey)
        
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -2, to: Date()) else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let queryDate = URLQueryItem(name: FlickrAPI.date.rawValue, value: formatter.string(from: yesterday))
        
        let queryExtras = URLQueryItem(name: FlickrAPI.extras.rawValue, value: "+\(FlickrAPIParameters.url_s)")
        let queryPerPage = URLQueryItem(name: FlickrAPI.perPage.rawValue, value: String(itemsPerPage))
        let queryPage = URLQueryItem(name: FlickrAPI.page.rawValue, value: String(page))
        let queryFormat = URLQueryItem(name: FlickrAPI.format.rawValue, value: FlickrAPIParameters.json.rawValue)
        let queryNoJSONCallBack = URLQueryItem(name: FlickrAPI.nojsoncallback.rawValue, value: String(1))
        
        components.queryItems = [queryMethod, queryAPIKey, queryDate, queryExtras, queryPerPage, queryPage, queryFormat, queryNoJSONCallBack]
        
        if let url = components.url {
            performURLRequestWith(url, completionHandler: completionHandler)
        }
    }
    
    // MARK: - Private Methods
    private func performURLRequestWith(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, urlRsponse, err) in
            if err == nil {
                completionHandler(data)
            }
            }.resume()
    }
    
    private func initializeURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = FlickrAPI.scheme.rawValue
        components.host = FlickrAPI.host.rawValue
        components.path = FlickrAPI.services.rawValue
        
        return components
    }
}
