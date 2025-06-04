//
//  NetworkError.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 20.05.25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case noData
    case requestFailed(Error)
}

