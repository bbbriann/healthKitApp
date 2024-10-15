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
    
    func performRequest<T: Decodable>(_ endpoint: String, method: String, 
                                      postData: Data? = nil,
                                      queryParams: [String: String]? = nil) -> AnyPublisher<T, Error> {
        // URLComponents로 URL을 생성하고 쿼리 파라미터를 추가
        var urlComponents = URLComponents(string: baseURLStr + endpoint)
        
        // GET 요청의 경우 쿼리 파라미터를 URL에 추가
        if method == "GET", let queryParams = queryParams {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        // URLComponents에서 최종 URL 생성
        guard let url = urlComponents?.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // POST나 PUT 요청의 경우 데이터 추가
        if let postData = postData, method != "GET" {
            request.httpBody = postData
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                print("[TEST] result.response \(result.response)")
                if let json = try? JSONSerialization.jsonObject(with: result.data, options: []) as? [String : Any] {
                    print("[TEST] data \(json)")
                }
                guard let response = result.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                if response.statusCode == 204 {
                    return Data() // 빈 데이터 반환
                }
                
                if result.data.isEmpty {
                    // 빈 데이터를 처리
                    return Data("{}".utf8) // 빈 객체로 처리
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
