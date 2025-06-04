//
//  NetworkManager.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 16.05.25.
//

import Foundation


protocol NetworkService {
    func request<T:Codable>(endpoint: Endpoint, completion: @escaping (Result<T,NetworkError>) -> Void)
}

final class NetworkManager : NetworkService {
    static let shared = NetworkManager()
    
    private init () {}
    
    func request<T:Codable>(endpoint: Endpoint, completion: @escaping (Result<T,NetworkError>) -> Void ) {
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            }
            catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}
