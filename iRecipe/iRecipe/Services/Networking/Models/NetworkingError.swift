//
//  NetworkingError.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case responseUnsuccessful(statusCode: Int)
    case dataSerializationFailed
}
