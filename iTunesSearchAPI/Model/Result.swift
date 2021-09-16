//
//  Result.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import Foundation

struct ApiResult: Codable {
    let results: [ResultList]
}

// MARK: - Result
struct ResultList: Codable {
    let screenshotUrls, ipadScreenshotUrls: [String]
}

