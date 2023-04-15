//
//  HomeViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation
import Combine

@MainActor protocol HomeViewModelServicing: ObservableObject {
    var searchText: String { get set }
    var searchedMeals: LoadingState<[Meal]> { get }
    var selectedCategory: Meal.Category? { get set }
    var mealsCategories: LoadingState<[Meal.Category]> { get }
    var mealsBySelectedCategory: LoadingState<[Meal]> { get }
}

@MainActor final class HomeViewModel: HomeViewModelServicing {
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Public properties
    @Published var searchText: String = ""
    @Published var searchedMeals: LoadingState<[Meal]>
    @Published var selectedCategory: Meal.Category?
    @Published var mealsCategories: LoadingState<[Meal.Category]>
    @Published var mealsBySelectedCategory: LoadingState<[Meal]>
    
    init() {
        mealsCategories = .initial
        searchedMeals = .loaded([])
        mealsBySelectedCategory = .initial
        connect()
    }
}

// MARK: - Public methods
extension HomeViewModel {
    func connect() {
        listenForSearchTextChange()
        listenForMealCategoryChange()
        fetchMealsCategories()
    }
}

// MARK: - Private methods
private extension HomeViewModel {
    func listenForSearchTextChange() {
        $searchText
            .sink { [weak self] mealName in
                let mealName = mealName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard mealName.isNotEmpty else { return }
                self?.fetchMeals(for: mealName)
            }
            .store(in: &subscriptions)
    }
    
    func fetchMeals(for mealName: String) {
        self.searchedMeals = .loading
        
        Task {
            do {
                let meals = try await GetSearchedMealsUseCase(searchedMealName: mealName).execute()
                self.searchedMeals = .loaded(meals)
            } catch {
                self.searchedMeals = .error(error)
            }
        }
    }
    
    func listenForMealCategoryChange() {
        $selectedCategory
            .sink { [weak self] mealCategory in
                guard let mealCategory else { return }
                self?.fetchMeals(for: mealCategory)
            }
            .store(in: &subscriptions)
    }
    
    func fetchMeals(for category: Meal.Category) {
        self.mealsBySelectedCategory = .initial
        Task {
            do {
                let meals = try await GetMealsByCategoryUseCase(category: category).execute()
                self.mealsBySelectedCategory = .loaded(meals)
            } catch {
                self.mealsBySelectedCategory = .error(error)
            }
        }
    }
    
    func fetchMealsCategories() {
        self.mealsCategories = .loading
        Task {
            do {
                let mealsCategories = try await GetMealsCategoriesUseCase().execute()
                self.mealsCategories = .loaded(mealsCategories)
                self.selectedCategory = mealsCategories.first
            } catch {
                self.mealsCategories = .error(error)
            }
        }
    }
}
