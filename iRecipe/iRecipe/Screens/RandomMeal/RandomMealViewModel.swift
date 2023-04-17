//
//  RandomMealViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

@MainActor protocol RandomMealViewModelServicing: ObservableObject {
    var meal: LoadingState<Meal> { get }
    
    func reconnect()
    func setFavorite(mealId: String)
}

@MainActor final class RandomMealViewModel: RandomMealViewModelServicing {
    // MARK: - Public properties
    @Published var meal: LoadingState<Meal>
    
    init() {
        meal = .initial
        connect()
    }
}

// MARK: - Public methods
extension RandomMealViewModel {
    func reconnect() {
        connect()
    }
    
    func setFavorite(mealId: String) {
        PreferenceService.Meals.setFavorite(mealId: mealId)
        
        if case .loaded(var meal) = meal {
            meal.isFavorite = false
            self.meal = .loaded(meal)
        } else {
            if case .loaded(var meal) = meal {
                meal.isFavorite = true
                self.meal = .loaded(meal)
            }
        }
    }
}

// MARK: - Private methods
private extension RandomMealViewModel {
    func connect() {
        fetchRandomMeal()
    }
    
    func fetchRandomMeal() {
        meal = .loading
        Task {
            do {
                var meal = try await GetRandoMealUseCase().execute()
                meal.isFavorite = PreferenceService.Meals.favoriteIds.contains(meal.id)
                self.meal = .loaded(meal)
            } catch {
                meal = .error(error)
            }
        }
    }
}
