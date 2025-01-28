import Foundation

class CitySearchVM {
    private var allCities: [City] = []
    private let networkService: NetworkServiceProtocol
    var Cities: [City]
    private var dummyCities: [City] = [
        City(
            geoNameId: 5128581,
            toponymName: "New York",
            cityName: "New York",
            countryName: "United States",
            countryCode: "US",
            administrativeRegion: "New York",
            latitude: "40.7128",
            longitude: "-74.0060",
            population: 8175133,
            featureCodeName: "seat of a first-order administrative division"
        ),
        City(
            geoNameId: 1850147,
            toponymName: "Tokyo",
            cityName: "Tokyo",
            countryName: "Japan",
            countryCode: "JP",
            administrativeRegion: "Tokyo",
            latitude: "35.6895",
            longitude: "139.6917",
            population: 13929286,
            featureCodeName: "capital of a political entity"
        ),
        City(
            geoNameId: 2643743,
            toponymName: "London",
            cityName: "London",
            countryName: "United Kingdom",
            countryCode: "GB",
            administrativeRegion: "England",
            latitude: "51.5074",
            longitude: "-0.1278",
            population: 8908081,
            featureCodeName: "capital of a political entity"
        ),
        City(
            geoNameId: 2988507,
            toponymName: "Paris",
            cityName: "Paris",
            countryName: "France",
            countryCode: "FR",
            administrativeRegion: "Île-de-France",
            latitude: "48.8566",
            longitude: "2.3522",
            population: 2148327,
            featureCodeName: "capital of a political entity"
        )
    ]
    
    var onCitiesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        Cities = dummyCities
    }
    
    var cityCount: Int {
        return allCities.count
    }
    
    func city(at index: Int) -> City {
        return allCities[index]
    }
    
    func fetchCities(query: String) {
        let urlString = "https://secure.geonames.org/searchJSON?name_startsWith=\(query)&maxRows=10&username=keep_truckin"
        
        NetworkService.shared.fetchData(urlString: urlString) { [weak self] (result: Result<CityResponse, Error>) in
            switch result {
            case .success(let cityResponse):
                print(cityResponse)
                self?.allCities = cityResponse.geoNames
                print(cityResponse.geoNames)
                DispatchQueue.main.async {
                    self?.onCitiesUpdated?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func setTestCities(_ testCities: [City]) {
        allCities = testCities
        onCitiesUpdated?()
    }
    
    func resetToDummyData() {
        allCities = dummyCities
        onCitiesUpdated?()
    }
}
