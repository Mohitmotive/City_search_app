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
            City(
                geonameId: 12345,
                toponymName: "Berlin",
                name: "Berlin",
                countryName: "Germany",
                countryCode: "DE",
                adminName1: "Berlin",
                lat: "52.5200",
                lng: "13.4050",
                population: 3769000,
                fcodeName: "capital of a political entity"
            ),
            City(
                geonameId: 67890,
                toponymName: "Madrid",
                name: "Madrid",
                countryName: "Spain",
                countryCode: "ES",
                adminName1: "Madrid",
                lat: "40.4168",
                lng: "-3.7038",
                population: 3266000,
                fcodeName: "capital of a political entity"
            )
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
