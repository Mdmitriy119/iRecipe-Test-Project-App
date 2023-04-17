//
//  MealDetailsViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 16.04.2023.
//

import Foundation

@MainActor protocol MealDetailsViewModelServicing: ObservableObject {
    /// Needed for nav bar title
    var mealName: String { get }
    var meal: LoadingState<Meal> { get }
    
    func setFavorite(mealId: String)
    func getFormattedIngredientsWithMeasures() -> [String: String]
}

@MainActor final class MealDetailsViewModel: MealDetailsViewModelServicing {
    // MARK: - Private properties
    @Storage(key: "favoriteMealsIds", defaultValue: [])
    private var favoriteMealsIds: [String]
    
    // MARK: - Public properties
    let mealName: String
    @Published var meal: LoadingState<Meal>
    
    init(meal: Meal, shouldFetchMealDetails: Bool = false) {
        self.mealName = meal.name
        if shouldFetchMealDetails {
            self.meal = .initial
            connect(with: meal.id)
        } else {
            self.meal = .loaded(meal)
        }
    }
}

// MARK: - Public methods
extension MealDetailsViewModel {
    func setFavorite(mealId: String) {
        if let index = favoriteMealsIds.firstIndex(of: mealId) {
            favoriteMealsIds.remove(at: index)
        } else {
            favoriteMealsIds.append(mealId)
        }
        
        if case .loaded(let meal) = meal {
            let adaptedMeal = markMealAsFavoriteIfNeeded(meal: meal)
            self.meal = .loaded(adaptedMeal)
        }
    }
    
    func getFormattedIngredientsWithMeasures() -> [String: String] {
        guard case .loaded(let meal) = meal  else { return [:] }
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
    func connect(with mealId: String) {
        fetchMealDetails(with: mealId)
    }
    
    func fetchMealDetails(with mealId: String) {
        Task {
            do {
                let meal = try await GetFavoriteMealByIdUseCase(mealId: mealId).execute()
                let adaptedMeal = markMealAsFavoriteIfNeeded(meal: meal)
                self.meal = .loaded(adaptedMeal)
            } catch {
                self.meal = .error(error)
            }
        }
    }
                
    func markMealAsFavoriteIfNeeded(meal: Meal) -> Meal {
        var meal = meal
        meal.isFavorite = favoriteMealsIds.contains(meal.id)
        return meal
    }
}
