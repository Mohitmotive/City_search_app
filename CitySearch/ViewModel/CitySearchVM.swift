import Foundation
import Combine

class CitySearchVM: ObservableObject {
    private let networkService: NetworkServiceProtocol
    var networkMonitor = NetworkMonitor()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var allCities: [City] = []
    @Published var isError: Bool = false
    
    // Closure properties for callbacks
    var onCitiesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        
        // Observe network connectivity
        networkMonitor.$isConnected
            .sink { [weak self] isConnected in
                if !isConnected {
                    self?.isError = true
                } else {
                    self?.isError = false
                }
            }
            .store(in: &cancellables)
    }

    var cityCount: Int {
        return allCities.count
    }

    func city(at index: Int) -> City {
        return allCities[index]
    }

    func fetchCities(query: String) {
        guard networkMonitor.isConnected else {
            // Handle offline mode, e.g., load cached data
            return
        }
        
        // Perform network request
        networkService.fetchCities(query: query) { [weak self] result in
            switch result {
            case .success(let cities):
                self?.allCities = cities
                self?.onCitiesUpdated?()
            case .failure(let error):
                self?.isError = true
                self?.onError?(error.localizedDescription)
            }
        }
    }

    func setTestCities(_ testCities: [City]) {
        allCities = testCities
        onCitiesUpdated?() 
    }
}
