//
//  GetSearchedMealsUseCase.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

struct GetSearchedMealsUseCase: UseCase {
    typealias Output = [Meal]
    
    private let searchText: String
    private let networkingService: NetworkingServicing
    
    init(searchText: String,
         networkingService: NetworkingServicing = NetworkService()) {
        self.searchText = searchText
        self.networkingService = networkingService
    }
    
    func execute() async throws -> Output {
        do {
            let mealsDictionary = try await networkingService
                .fetchDataDecoded(
                    from: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(searchText)",
                    as: [String: [Meal]].self) // ["meals": []] -> Bad data format from API :/
            if let meals = mealsDictionary["meals"] {
                return meals
            } else {
                throw NetworkError.dataSerializationFailed
            }
        } catch {
            throw error
        }
    }
}
