//
//  GetRandomMealUseCase.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

struct GetRandoMealUseCase: UseCase {
    typealias Output = Meal
    
    private let networkingService: NetworkingServicing
    
    init(networkingService: NetworkingServicing = NetworkService()) {
        self.networkingService = networkingService
    }
    
    func execute() async throws -> Output {
        do {
            // ["meals": []] -> Bad data format from API, when there is no possibility to request for multiple meales in the same request :/
            let mealsDictionary = try await networkingService
                .fetchDataDecoded(
                    from: Constants.UseCases.randomEndpoint,
                    as: [String: [Meal]].self)
            if let meals = mealsDictionary[Constants.UseCases.mealsKey],
               let meal = meals.first {
                return PreferenceService.Meals.markMealAsFavoriteIfNeeded(meal: meal)
            } else {
                throw NetworkError.dataSerializationFailed
            }
        } catch {
            throw error
        }
    }
}
