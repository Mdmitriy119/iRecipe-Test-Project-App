//
//  GetMealsByCategoryUseCase.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

struct GetMealsByCategoryUseCase: UseCase {
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
                    from: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category.name.rawValue)",
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
