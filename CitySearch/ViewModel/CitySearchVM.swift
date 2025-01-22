import Foundation

class CitySearchVM {
    var allCities: [City] = []
    private let networkService: NetworkServiceProtocol

    var onCitiesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    var cityCount: Int {
        return allCities.count
    }

    func city(at index: Int) -> City {
        return allCities[index]
    }

    func fetchCities(query: String) {
        let urlString =
            "https://secure.geonames.org/searchJSON?name_startsWith=\(query)&maxRows=10&username=keep_truckin"

        networkService.fetchData(urlString: urlString) {
            [weak self] (result: Result<CityResponse, Error>) in
            switch result {
            case .success(let cityResponse):
                DispatchQueue.main.async {
                    guard !cityResponse.geoNames.isEmpty else {
                        self?.allCities = []
                        self?.onCitiesUpdated?()
                        self?.onError?(
                            "No cities found for the query '\(query)'.")
                        return
                    }

                    self?.allCities = cityResponse.geoNames
                    self?.onCitiesUpdated?()
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self?.allCities = []
                    self?.onCitiesUpdated?()
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }

    func setTestCities(_ testCities: [City]) {
        allCities = testCities
        onCitiesUpdated?()
    }
}
