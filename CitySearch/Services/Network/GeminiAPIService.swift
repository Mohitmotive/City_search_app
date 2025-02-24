import Foundation

class GeminiAPIService {
    private let apiKey = "AIzaSyDbolvl19zKXmRfPVm38X6LvLTkmatt89s"
    private let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

    func getAIResponse(for userMessage: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else {
            completion("Invalid API URL")
            return
        }

        let requestBody: [String: Any] = [
            "contents": [
                ["parts": [["text": userMessage]]]
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion("Failed to encode request")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion("No data received from API")
                return
            }

            do {
                print("API Response: \(String(data: data, encoding: .utf8) ?? "Invalid response")")

                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let candidates = jsonResponse["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String {
                    completion(text)
                } else {
                    completion("No valid AI response found")
                }
            } catch {
                completion("Error decoding response: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
