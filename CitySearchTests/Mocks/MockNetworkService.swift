//
//  MockNetworkService.swift
//  CitySearch
//
//  Created by Mohit Kumar on 29/01/25.
//

import XCTest

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Data, Error>?

    func fetchData<T: Decodable>(
        urlString: String, completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let result = result else {
            XCTFail("Result not set")
            return
        }
        switch result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
