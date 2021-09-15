//
//  Result.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import Foundation

struct Result {
    var name: String
    var price: Double
    var description: String
    var formattedPrice: String
    var artworkUrl: URL?
    var itunesUrl: URL?
    
    private struct APIKeys {
        static let name = "trackName"
        static let artworkURL = "artworkUrl512"
        static let description = "description"
        static let formattedPrice = "formattedPrice"
        static let price = "price"
    }
    
    init?(dictionary: [String : Any])
    {
        guard let name = dictionary[APIKeys.name] as? String,
            let artworkURLString = dictionary[APIKeys.artworkURL] as? String,
            let description = dictionary[APIKeys.description] as? String,
            let formattedPrice = dictionary[APIKeys.formattedPrice] as? String,
            let price = dictionary[APIKeys.price] as? Double else {
            return nil
        }
        
        self.name = name
        self.artworkUrl = URL(string: artworkURLString)
        self.description = description
        self.formattedPrice = formattedPrice
        self.price = price
    }
}
