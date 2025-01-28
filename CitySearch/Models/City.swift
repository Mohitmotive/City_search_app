//
//  City.swift
//  CitySearch
//
//  Created by Mohit Kumar on 21/01/25.
//

import Foundation

struct City: Codable {
    let geoNameId: Int
    let toponymName: String
    let cityName: String
    let countryName: String
    let countryCode: String
    let administrativeRegion: String
    let latitude: String
    let longitude: String
    let population: Int
    let featureCodeName: String

    enum CodingKeys: String, CodingKey {
        case geoNameId = "geonameId"
        case toponymName
        case cityName = "name"
        case countryName
        case countryCode
        case administrativeRegion = "adminName1"
        case latitude = "lat"
        case longitude = "lng"
        case population
        case featureCodeName = "fcodeName"
    }
}




