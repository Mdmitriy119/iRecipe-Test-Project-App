//
//  GetMealsForCategoryUseCase.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

struct GetMealsForCategoryUseCase: UseCase {
    typealias Output = [Meal]
    
    private let category: Meal.Category
    private let networkingService: NetworkingServicing
    
    init(category: Meal.Category,
         networkingService: NetworkingServicing = NetworkService()) {
        self.category = category
        self.networkingService = networkingService
    }
    
    func execute() async throws -> Output {
        do {
            let mealsDictionary = try await networkingService
                .fetchDataDecoded(
                    from: "\(Constants.UseCases.mealsForCategoryEndpoint)\(category.name.rawValue)",
                    as: [String: [Meal]].self) // ["meals": []] -> Bad data format from API :/
            if let meals = mealsDictionary[Constants.UseCases.mealsKey] {
                return PreferenceService.Meals.markMealsAsFavoriteIfNeeded(meals: meals)
            } else {
                throw NetworkError.dataSerializationFailed
            }
        } catch {
            throw error
        }
    }
}
