//
//  NetworkController.swift
//  CitySearch
//
//  Created by Mohit Kumar on 21/01/25.
//

import Foundation

class NetworkController {
    static func fetchCities(query: String, completion: @escaping (Result<[City], Error>) -> Void) {
        let urlString = "https://secure.geonames.org/searchJSON?name_startsWith=\(query)&maxRows=10&username=keep_truckin"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let cityResponse = try JSONDecoder().decode(CityResponse.self, from: data)
                completion(.success(cityResponse.geonames))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
