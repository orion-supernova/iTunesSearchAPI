//
//  NetworkClient.swift
//  iTunesSearchAPI
//
//  Created by Murat Can KOÇ on 15.09.2021.
//

import Foundation

struct NetworkClient {

    func fetchResults(withTerm term: String, completion: @escaping ([Result]?) -> Void) {
        
        // 1. endpoint
        let searchEndpoint = APIEndpoint.search(term: term)
        let searchUrlRequest = searchEndpoint.request
        
        // 2. network processor
        let networkProcessor = NetworkProcessor(request: searchUrlRequest)
        networkProcessor.downloadJSON { (jsonResponse, httpResponse, error) in
            
            DispatchQueue.main.async {
                // 3. get the array of result dictionaries
                guard let json = jsonResponse,
                    let resultDictionaries = json["results"] as? [[String : Any]] else {
                        completion(nil)
                        return
                }
                
                // 4. create an array of results
                let results = resultDictionaries.compactMap({ resultDictionary in
                    return Result(dictionary: resultDictionary)
                })
                
                // 5. call completion
                completion(results)
                print("DEBUG-- \(networkProcessor.request)")
            }
        }
    }
    
}
