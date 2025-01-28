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
                geoNameId: 12345,
                toponymName: "Berlin",
                cityName: "Berlin",
                countryName: "Germany",
                countryCode: "DE",
                administrativeRegion: "Berlin",
                latitude: "52.5200",
                longitude: "13.4050",
                population: 3769000,
                featureCodeName: "capital of a political entity"
            ),
            City(
                geoNameId: 67890,
                toponymName: "Madrid",
                cityName: "Madrid",
                countryName: "Spain",
                countryCode: "ES",
                administrativeRegion: "Madrid",
                latitude: "40.4168",
                longitude: "-3.7038",
                population: 3266000,
                featureCodeName: "capital of a political entity"
            )
        ]

        
        viewModel.setTestCities(mockCities)
        XCTAssertEqual(viewModel.cityCount, 2, "City count should match mock response.")
        
        let firstCity = viewModel.city(at: 0)
        XCTAssertEqual(firstCity.toponymName, "Berlin")
        XCTAssertEqual(firstCity.administrativeRegion, "Berlin")
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
