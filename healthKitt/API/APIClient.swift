//
//  APIClient.swift
//  healthKitt
//
//  Created by brian on 9/10/24.
//

import SwiftUI
import Combine

// MARK: - APIClient
class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private let baseURLStr = "https://phenotrack-api-dev.fly.dev/api"
    
    func performRequest<T: Decodable>(_ endpoint: String, method: String, parameters: [String: Any]? = nil) -> AnyPublisher<T, Error> {
        guard let url = URL(string: baseURLStr + endpoint) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
