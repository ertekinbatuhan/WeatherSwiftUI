//
//  NetworkManager.swift
//  Weather App

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private let apiKey = APIConstants.API_KEY
    
    func fetchWeather(for city: String = "istanbul", completion: @escaping (Result<Weather, NetworkError>) -> Void) {
        guard let url = URL(string: "\(APIConstants.BASE_URL)weather?q=\(city)&appid=\(apiKey)&units=metric") else {
            completion(.failure(.invalidURL))
            return
        }

        
        AF.request(url, method: .get).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let underlyingError = error.underlyingError {
                    completion(.failure(.requestFailed(underlyingError)))
                } else {
                    completion(.failure(.invalidResponse))
                }
            }
        }
    }
}
