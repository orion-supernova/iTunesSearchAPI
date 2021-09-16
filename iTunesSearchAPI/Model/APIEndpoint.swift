//
//  APIEndpoint.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import Foundation

enum APIEndpoint {
    case search(term: String)
    
    var request: URLRequest {
        var components = URLComponents(string: baseURL)!
        components.path = path
        components.queryItems = queryComponents
        
        let url = components.url!
        return URLRequest(url: url)
    }
    
    private var baseURL: String {
        return "https://itunes.apple.com/"
    }
    private var path: String {
        switch self {
        case .search:
            return "/search"
            
        }
    }
    private struct ParameterKeys {
        static let country = "country"
        static let term = "term"
        static let entity = "entity"
        static let media = "media"
    }
    private struct DefaultValues {
        static let country = "us"
        static let term = "apple"
        static let media = "software"
        static let entity = "software"
    }
    
    private var parameters: [String : Any] {
        switch self {
        case .search(let term):
            let parameters: [String : Any] = [
                ParameterKeys.term : term,
                ParameterKeys.entity : DefaultValues.entity,
                ParameterKeys.country : DefaultValues.country,
                ParameterKeys.media : DefaultValues.media
            ]
            
            return parameters
        }
    }
    
    private var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.append(queryItem)
        }
        
        return components
    }
}
