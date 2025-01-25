//
//  MockNetworkServiceTests.swift
//  CitySearchTests
//
//  Created by Mohit Kumar on 24/01/25.
//

import XCTest
@testable import CitySearch

final class MockNetworkServiceTests: XCTestCase {

    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
    }
    
    override func tearDown() {
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() {
        let mockCityResponse = City(toponymName: "London", adminName1: "England", countryName: "United Kingdom")
        mockNetworkService.mockResponse = mockCityResponse
        
        let expectation = self.expectation(description: "Success response received")
        mockNetworkService.fetcData(urlString: "mock_url") { (result: Result<City, any Error>) in
            switch result {
            case .success(let city):
                XCTAssertEqual(city.toponymName, "London", "The city name should match the mock response.")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure.")
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchDataError() {
        mockNetworkService.shouldReturnError = true
        
        let expectation = self.expectation(description: "Error response received")
        
        mockNetworkService.fetcData(urlString: "mock_url") { (result: Result<City, any Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure but got success.")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "MockError", "Error domain should match MockError.")
                XCTAssertEqual((error as NSError).code, 1, "Error code should be 1.")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchDataInvalidResponse() {
        mockNetworkService.mockResponse = "Invalid Response"
        
        let expectation = self.expectation(description: "Invalid response error received")
        
        mockNetworkService.fetcData(urlString: "mock_url") { (result: Result<City, any Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure but got success.")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "MockError", "Error domain should match MockError.")
                XCTAssertEqual((error as NSError).code, 2, "Error code should be 2.")
                XCTAssertEqual((error as NSError).userInfo[NSLocalizedDescriptionKey] as? String, "Invalid Mock Response", "Error description should match.")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
