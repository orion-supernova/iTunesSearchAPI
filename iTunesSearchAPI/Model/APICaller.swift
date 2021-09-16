//
//  APICaller.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 16.09.2021.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    // MARK- Untouched API URL for fetch example "https://itunes.apple.com/search?country=us&term=amazon&entity=software&media=software"
    enum Constants {
        static let defaultUrl = URL(string: defaultUrlBeforeTerm + defaultUrlTerm)
        static let defaultUrlBeforeTerm = "https://itunes.apple.com/search?country=us&entity=software&media=software&term="
        static let defaultUrlTerm = "amazon"
    }
    
    func getResults(term: String, completion: @escaping (Result<[ResultList], Error>) -> Void) {
        
        let queryParam = term.replacingOccurrences(of: " ", with: "+")
        let urlString = Constants.defaultUrlBeforeTerm + queryParam
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ApiResult.self, from: data)
//                    print(result.results[0].screenshotUrls)
                    completion(.success(result.results))
                } catch  {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
    }
}
