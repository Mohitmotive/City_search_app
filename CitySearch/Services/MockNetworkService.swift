//
//  MockNetworkService.swift
//  CitySearch
//
//  Created by Mohit Kumar on 24/01/25.
//

import Foundation

class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var mockResponse: Decodable?
    
    
    func fetchData<T>(urlString: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        
    }
    func fetcData<T>(urlString: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: nil)))
        } else if let response = mockResponse as? T {
            completion(.success(response))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid Mock Response"])))
        }
    }
}



