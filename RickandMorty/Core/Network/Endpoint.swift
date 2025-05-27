//
//  Endpoint.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 20.05.25.
//

import Foundation

struct Endpoint {
    let baseURL: String
    let path: String
    var queryItems: [URLQueryItem] = []
    var method: HTTPMethods = .get
    var headers: [String: String] = [:]
    var body: Data? = nil

    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path += path
        components?.queryItems = queryItems
        return components?.url
    }

    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
