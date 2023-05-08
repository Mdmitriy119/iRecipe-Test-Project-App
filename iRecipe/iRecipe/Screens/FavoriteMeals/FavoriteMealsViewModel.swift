//
//  FavoriteMealsViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

@MainActor protocol FavoriteMealsViewModelServicing: ObservableObject {
    var isFavoriteMealsLoading: Bool { get }
    var favoriteMeals: [Meal] { get }
    var errorWhileFetchingFavoriteMeals: Error? { get }
    
    func connect()
}

@MainActor final class FavoriteMealsViewModel: FavoriteMealsViewModelServicing {
    // MARK: - Public properties
    @Published var isFavoriteMealsLoading: Bool = false
    @Published var favoriteMeals: [Meal]
    @Published var errorWhileFetchingFavoriteMeals: Error?
    
    init() {
        favoriteMeals = []
    }
}

// MARK: - Public methods
extension FavoriteMealsViewModel {
    func connect() {
        fetchFavoriteMeals()
    }
}

// MARK: - Private methods
private extension FavoriteMealsViewModel {
    func fetchFavoriteMeals() {
        errorWhileFetchingFavoriteMeals = nil
        isFavoriteMealsLoading = true
        
        Task {
            do {
                let meals = try await withThrowingTaskGroup(of: Meal.self) { taskGroup in
                    PreferenceService.Meals.favoriteIds.forEach { id in
                        taskGroup.addTask { try await GetMealByIdUseCase(mealId: id).execute() }
                    }
                    return try await taskGroup.reduce(into: [Meal]()) { $0.append($1) }
                }
                self.favoriteMeals = meals.sorted(by: { $0.id < $1.id })
                isFavoriteMealsLoading = false
            } catch {
                errorWhileFetchingFavoriteMeals = error
                isFavoriteMealsLoading = false
            }
        }
    }
}
