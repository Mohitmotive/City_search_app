import Foundation

class CitySearchViewModel {
    private var allCities: [City] = []
    private var dummyCities: [City] = [
        City(toponymName: "New York", adminName1: "New York", countryName: "USA"),
        City(toponymName: "Tokyo", adminName1: "Tokyo", countryName: "Japan"),
        City(toponymName: "London", adminName1: "England", countryName: "UK"),
        City(toponymName: "Paris", adminName1: "Île-de-France", countryName: "France")    ]
    var onCitiesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init() {
        allCities = dummyCities
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
    
    func resetToDummyData() {
        allCities = dummyCities
        onCitiesUpdated?()
    }
}
