//
//  CityResponse.swift
//  CitySearch
//
//  Created by Mohit Kumar on 21/01/25.
//
import Foundation

struct CityResponse: Codable {
    let geoNames: [City]

    enum CodingKeys: String, CodingKey {
        case geoNames = "geonames"
    }
}

