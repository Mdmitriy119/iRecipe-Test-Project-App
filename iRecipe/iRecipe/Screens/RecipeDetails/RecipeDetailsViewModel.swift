//
//  RecipeDetailsViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 16.04.2023.
//

import Foundation

protocol RecipeDetailsViewModelServicing: ObservableObject {
    /// Needed for nav bar title
    var mealName: String { get }
    var meal: LoadingState<Meal> { get }
}

final class RecipeDetailsViewModel: RecipeDetailsViewModelServicing {
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

// MARK: - Private methods
private extension RecipeDetailsViewModel {
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
