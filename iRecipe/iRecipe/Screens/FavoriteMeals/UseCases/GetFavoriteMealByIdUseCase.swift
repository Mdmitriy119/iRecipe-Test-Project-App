//
//  GetFavoriteMealByIdUseCase.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

struct GetFavoriteMealByIdUseCase: UseCase {
    typealias Output = Meal
    
    private let mealId: String
    private let networkingService: NetworkingServicing
    
    init(mealId: String,
         networkingService: NetworkingServicing = NetworkService()) {
        self.mealId = mealId
        self.networkingService = networkingService
    }
    
    func execute() async throws -> Output {
        do {
            // ["meals": []] -> Bad data format from API, when there is no possibility to request for multiple meales in the same request :/
            let mealsDictionary = try await networkingService
                .fetchDataDecoded(
                    from: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)",
                    as: [String: [Meal]].self)
            if let meals = mealsDictionary["meals"],
               var meal = meals.first {
                meal.isFavorite = true
                return meal
            } else {
                throw NetworkError.dataSerializationFailed
            }
        } catch {
            throw error
        }
    }
}
