//
//  NetworkServiceProtocol.swift
//  CitySearch
//
//  Created by Mohit Kumar on 28/01/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchCities(query: String, completion: @escaping (Result<[City], Error>) -> Void)
}
