//
//  RandomMealViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

@MainActor protocol RandomMealViewModelServicing: ObservableObject {
    var isMealLoading: Bool { get }
    var meal: Meal? { get }
    var errorWhileFetchingMeal: Error? { get }
    
    func reconnect()
}

@MainActor final class RandomMealViewModel: RandomMealViewModelServicing {
    // MARK: - Public properties
    @Published var isMealLoading: Bool = false
    @Published var meal: Meal?
    @Published var errorWhileFetchingMeal: Error?
    
    init() {
        connect()
    }
}

// MARK: - Public methods
extension RandomMealViewModel {
    func reconnect() {
        connect()
    }
}

// MARK: - Private methods
private extension RandomMealViewModel {
    func connect() {
        fetchRandomMeal()
    }
    
    func fetchRandomMeal() {
        errorWhileFetchingMeal = nil
        isMealLoading = true
        
        Task {
            do {
                let meal = try await GetRandoMealUseCase().execute()
                self.meal = meal
                isMealLoading = false
            } catch {
                errorWhileFetchingMeal = error
                isMealLoading = false
            }
        }
    }
}
