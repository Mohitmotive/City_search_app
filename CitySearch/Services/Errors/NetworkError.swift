//
//  NetworkError.swift
//  CitySearch
//
//  Created by Mohit Kumar on 29/01/25.
//

enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError(Error)
    case networkFailure(Error)
    case offline
}


