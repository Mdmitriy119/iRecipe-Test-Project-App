//
//  GetMealsCategoriesUseCase.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

struct GetMealsCategoriesUseCase: UseCase {
    typealias Output = [Meal.Category]
    
    private let networkingService: NetworkingServicing
    
    init(networkingService: NetworkingServicing = NetworkService()) {
        self.networkingService = networkingService
    }
    
    func execute() async throws -> Output {
        do {
            let categoriesDictionary = try await networkingService
                .fetchDataDecoded(
                    from: "https://www.themealdb.com/api/json/v1/1/categories.php",
                    as: [String: [Meal.Category]].self) // ["categories": []] -> Bad data format from API :/
            if let mealsCategories = categoriesDictionary["categories"] {
                return mealsCategories
            } else { 
                throw NetworkError.dataSerializationFailed
            }
        } catch {
            throw error
        }
    }
}
