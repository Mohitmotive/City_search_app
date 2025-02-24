import Foundation

class NetworkService: NetworkServiceProtocol {
    
    func fetchData<T>(urlString: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.networkFailure(error)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }
        task.resume()
    }

    func fetchCities(query: String, completion: @escaping (Result<[City], Error>) -> Void) {
        let urlString = "https://secure.geonames.org/searchJSON?name_startsWith=\(query)&maxRows=10&username=keep_truckin"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let cityResponse = try JSONDecoder().decode(CityResponse.self, from: data)
                completion(.success(cityResponse.geoNames))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
