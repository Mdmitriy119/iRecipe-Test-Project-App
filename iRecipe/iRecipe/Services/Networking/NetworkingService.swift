//
//  NetworkingService.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

protocol NetworkingServicing {
    func fetchDataDecoded<T: Decodable> (from stringUrl: String, as type: T.Type) async throws -> T
}

struct NetworkService: NetworkingServicing {
    func fetchDataDecoded<T: Decodable>(from stringUrl: String, as type: T.Type) async throws -> T {
        let data = try await fetchData(from: stringUrl)
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch {
            throw NetworkError.dataSerializationFailed
        }
    }
}

// MARK: - Private methods
private extension NetworkService {
    func fetchData(from stringUrl: String) async throws -> Data {
        guard let url = URL(string: stringUrl) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.responseUnsuccessful(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        return data
    }
}
