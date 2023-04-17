//
//  FavoriteMealsViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

@MainActor protocol FavoriteMealsViewModelServicing: ObservableObject {
    var favoriteMeals: LoadingState<[Meal]> { get }
    
    func connect()
    func removeFavorite(mealId: String)
}

@MainActor final class FavoriteMealsViewModel: FavoriteMealsViewModelServicing {
    // MARK: - Public properties
    @Published var favoriteMeals: LoadingState<[Meal]>
    
    init() {
        favoriteMeals = .initial
    }
}

// MARK: - Public methods
extension FavoriteMealsViewModel {
    func connect() {
        fetchFavoriteMeals()
    }
    
    func removeFavorite(mealId: String) {
        PreferenceService.Meals.setFavorite(mealId: mealId)
        if case .loaded(var meals) = favoriteMeals {
            meals.removeAll(where: { $0.id == mealId } )
            favoriteMeals = .loaded(meals)
        }
    }
}

// MARK: - Private methods
private extension FavoriteMealsViewModel {
    func fetchFavoriteMeals() {
        favoriteMeals = .loading
        Task {
            do {
                let meals = try await withThrowingTaskGroup(of: Meal.self) { taskGroup in
                    PreferenceService.Meals.favoriteIds.forEach { id in
                        taskGroup.addTask { try await GetFavoriteMealByIdUseCase(mealId: id).execute() }
                    }
                    return try await taskGroup.reduce(into: [Meal]()) { $0.append($1) }
                }
                let sortedMeals = meals.sorted(by: { $0.id < $1.id })
                favoriteMeals = .loaded(sortedMeals)
            } catch {
                favoriteMeals = .error(error)
            }
        }
    }
}
