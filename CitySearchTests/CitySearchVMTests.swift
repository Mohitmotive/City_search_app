import XCTest
@testable import CitySearch

class CitySearchVMTests: XCTestCase {
    
    var viewModel: CitySearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CitySearchViewModel()
    }
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchCitiesWithQuery() {
        let mockCities = [
            City(toponymName: "Berlin", adminName1: "Berlin", countryName: "Germany"),
            City(toponymName: "Madrid", adminName1: "Madrid", countryName: "Spain")
        ]
        
        viewModel.setTestCities(mockCities)
        XCTAssertEqual(viewModel.cityCount, 2, "City count should match mock response.")
        
        let firstCity = viewModel.city(at: 0)
        XCTAssertEqual(firstCity.toponymName, "Berlin")
        XCTAssertEqual(firstCity.adminName1, "Berlin")
        XCTAssertEqual(firstCity.countryName, "Germany")
    }

    func testFetchCitiesWithError() {

        let mockError = "Failed to fetch cities."
        viewModel.onError = { error in
            XCTAssertEqual(error, mockError, "Error message should match the simulated error.")
        }
        viewModel.onError?(mockError)
    }
}
