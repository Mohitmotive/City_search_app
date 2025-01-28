//
//  NetworkServiceProtocol.swift
//  CitySearch
//
//  Created by Mohit Kumar on 28/01/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void)
}
