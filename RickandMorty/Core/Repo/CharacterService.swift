//
//  CharacterService.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 21.05.25.
//

import Foundation

final class CharacterService {
    private let networkService : NetworkService
    
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func fetchCharacters(
        name: String?,
        currentFilters: [String?: String?],
        page: Int,
        completion: @escaping (Result<CharacterResponse, NetworkError>) -> Void
    ) {
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        if let name = name, !name.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: name))
        }
        currentFilters.forEach { key, value in
            if let value = value, !value.isEmpty, let key = key, !key.isEmpty {
                queryItems.append(URLQueryItem(name: key.lowercased(), value: value.lowercased()))
            }
        }
        
        print(queryItems)
        let endpoint = Endpoint(
            baseURL: "https://rickandmortyapi.com/api",
            path: "/character",
            queryItems: queryItems
        )
        
        networkService.request(endpoint: endpoint, completion: completion)
    }
    
}
