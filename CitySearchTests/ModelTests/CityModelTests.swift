//
//  CityModelTests.swift
//  CitySearch
//
//  Created by Mohit Kumar on 29/01/25.
//

import XCTest
@testable import CitySearch

class ModelTests: XCTestCase {
    
    func testCityDecoding() throws {
        let json = """
        {
            "geonameId": 5391959,
            "toponymName": "San Francisco",
            "name": "San Francisco",
            "countryName": "United States",
            "countryCode": "US",
            "adminName1": "California",
            "lat": "37.7749",
            "lng": "-122.4194",
            "population": 883305,
            "fcodeName": "city"
        }
        """.data(using: .utf8)!
        
        let city = try JSONDecoder().decode(City.self, from: json)
        
        XCTAssertEqual(city.geoNameId, 5391959)
        XCTAssertEqual(city.topographicalName, "San Francisco")
        XCTAssertEqual(city.administrativeRegion, "California")
    }
    
    func testCityResponseDecoding() throws {
        let json = """
        {
            "geonames": [
                {
                    "geonameId": 5391959,
                    "toponymName": "San Francisco",
                    "name": "San Francisco",
                    "countryName": "United States",
                    "countryCode": "US",
                    "adminName1": "California",
                    "lat": "37.7749",
                    "lng": "-122.4194",
                    "population": 883305,
                    "fcodeName": "city"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(CityResponse.self, from: json)
        XCTAssertEqual(response.geoNames.count, 1)
        XCTAssertEqual(response.geoNames[0].countryCode, "US")
    }
}
