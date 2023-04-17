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
    // MARK: - Private properties
    @Storage(key: "favoriteMealsIds", defaultValue: [])
    private var favoriteMealsIds: [String]
    
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
        if let index = favoriteMealsIds.firstIndex(of: mealId) {
            favoriteMealsIds.remove(at: index)
            if case .loaded(var meal) = meal {
                meal.isFavorite = false
                self.meal = .loaded(meal)
            }
        } else {
            favoriteMealsIds.append(mealId)
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
                meal.isFavorite = favoriteMealsIds.contains(meal.id)
                self.meal = .loaded(meal)
            } catch {
                meal = .error(error)
            }
        }
    }
}
