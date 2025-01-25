import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T:Decodable>(urlString : String ,completion: @escaping (Result<T, Error>) -> Void)
}

class CitySearchViewModel {
    private var allCities: [City] = []
    private let networkService: NetworkServiceProtocol
    var Cities: [City]
    private var dummyCities: [City] = [
        City(
                geonameId: 5128581,
                toponymName: "New York",
                name: "New York",
                countryName: "United States",
                countryCode: "US",
                adminName1: "New York",
                lat: "40.7128",
                lng: "-74.0060",
                population: 8175133,
                fcodeName: "seat of a first-order administrative division"
            ),
            City(
                geonameId: 1850147,
                toponymName: "Tokyo",
                name: "Tokyo",
                countryName: "Japan",
                countryCode: "JP",
                adminName1: "Tokyo",
                lat: "35.6895",
                lng: "139.6917",
                population: 13929286,
                fcodeName: "capital of a political entity"
            ),
            City(
                geonameId: 2643743,
                toponymName: "London",
                name: "London",
                countryName: "United Kingdom",
                countryCode: "GB",
                adminName1: "England",
                lat: "51.5074",
                lng: "-0.1278",
                population: 8908081,
                fcodeName: "capital of a political entity"
            ),
            City(
                geonameId: 2988507,
                toponymName: "Paris",
                name: "Paris",
                countryName: "France",
                countryCode: "FR",
                adminName1: "Île-de-France",
                lat: "48.8566",
                lng: "2.3522",
                population: 2148327,
                fcodeName: "capital of a political entity"
            )   ]
    
    var onCitiesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared ) {
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
                
                self?.allCities = cityResponse.geonames
                print(cityResponse.geonames)
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
