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
                    from: "\(Constants.UseCases.searchEnpoint)\(searchText)",
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
