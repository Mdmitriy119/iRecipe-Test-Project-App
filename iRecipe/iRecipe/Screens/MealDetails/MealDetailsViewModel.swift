//
//  MealDetailsViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 16.04.2023.
//

import Foundation
import SwiftUI

@MainActor protocol MealDetailsViewModelServicing: ObservableObject {
    var isMealLoading: Bool { get }
    var meal: Meal { get }
    var errorWhileFetchingMeal: Error? { get }

    func connect()
    func getFormattedIngredientsWithMeasures() -> [String: String]
}

@MainActor final class MealDetailsViewModel: MealDetailsViewModelServicing {
    // MARK: - Private properties
    private let shouldFetchMealDetails: Bool
    
    // MARK: - Public properties
    @Published var isMealLoading: Bool = false
    @Binding var meal: Meal
    @Published var errorWhileFetchingMeal: Error?
    
    init(meal: Binding<Meal>, shouldFetchMealDetails: Bool = false) {
        self._meal = meal
        self.shouldFetchMealDetails = shouldFetchMealDetails
    }
}

// MARK: - Public methods
extension MealDetailsViewModel {
    func connect() {
        if shouldFetchMealDetails {
            fetchMealDetails(with: meal.id)
        }
    }
    
    func getFormattedIngredientsWithMeasures() -> [String: String] {
        var ingredientsWithMeasures: [String: String] = [:]
        var ingredients: [String] = []
        var measures: [String] = []
        
        let mirrorMeal = Mirror(reflecting: meal)
        for child in mirrorMeal.children {
            // Filter ingredients
            if let label = child.label,
               label.contains("ingredient"),
               let value = child.value as? String?,
               let nonOptionalValue = value,
               nonOptionalValue.isNotEmpty {
                ingredients.append(nonOptionalValue)
            }
            
            // Filter measures
            if let label = child.label,
               label.contains("measure"),
               let value = child.value as? String?,
               let nonOptionalValue = value,
               nonOptionalValue.isNotEmpty {
                measures.append(nonOptionalValue)
            }
        }
        
        let ingredientsAndMeasuresCount = min(ingredients.count, measures.count)
        for index in 0..<ingredientsAndMeasuresCount {
            ingredientsWithMeasures[ingredients[index]] = measures[index]
        }

        return ingredientsWithMeasures
    }
}

// MARK: - Private methods
private extension MealDetailsViewModel {
    func fetchMealDetails(with mealId: String) {
        errorWhileFetchingMeal = nil
        isMealLoading = true
        
        Task {
            do {
                meal = try await GetMealByIdUseCase(mealId: mealId).execute()
                isMealLoading = false
            } catch {
                self.errorWhileFetchingMeal = error
                isMealLoading = false
            }
        }
    }
}
