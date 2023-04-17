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
    var isSearchedMealsLoading: Bool { get }
    var searchedMeals: [Meal] { get }
    var errorWhileFetchingSearchedMeals: Error? { get }
    var selectedCategory: Meal.Category? { get set }
    var mealsCategories: LoadingState<[Meal.Category]> { get }
    var isMealsForCategoryLoading: Bool { get }
    var mealsForSelectedCategory: [Meal] { get }
    var errorWhileFetchingMealForCategory: Error? { get }
    
    func refreshMealsIfNeeded()
}

@MainActor final class HomeViewModel: HomeViewModelServicing {
    // MARK: - Private methods
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Public properties
    @Published var searchText: String = ""
    @Published var isSearchedMealsLoading: Bool = false
    @Published var searchedMeals: [Meal]
    @Published var errorWhileFetchingSearchedMeals: Error?
    @Published var selectedCategory: Meal.Category?
    @Published var mealsCategories: LoadingState<[Meal.Category]>
    @Published var isMealsForCategoryLoading: Bool = false
    @Published var mealsForSelectedCategory: [Meal]
    @Published var errorWhileFetchingMealForCategory: Error?
    
    init() {
        searchedMeals = []
        mealsCategories = .initial
        mealsForSelectedCategory = []
        connect()
    }
}

// MARK: - Public methods
extension HomeViewModel {
    /// Refresh meals when these were marked fav/no fav from different screens
    func refreshMealsIfNeeded() {
        // Searched meals
        searchedMeals = PreferenceService.Meals.markMealsAsFavoriteIfNeeded(meals: searchedMeals)
        
        // Meals for category
        mealsForSelectedCategory = PreferenceService.Meals.markMealsAsFavoriteIfNeeded(meals: mealsForSelectedCategory)
    }
}

// MARK: - Private methods
private extension HomeViewModel {
    func connect() {
        listenForSearchTextChange()
        listenForMealCategoryChange()
        fetchMealsCategories()
    }
    
    func listenForSearchTextChange() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard searchText.isNotEmpty else {
                    self?.searchedMeals = []
                    return
                }
                self?.fetchMeals(for: searchText)
            }
            .store(in: &subscriptions)
    }
    
    func fetchMeals(for searchText: String) {
        self.isSearchedMealsLoading = true
        
        Task {
            do {
                searchedMeals = try await GetSearchedMealsUseCase(searchText: searchText).execute()
                isSearchedMealsLoading = false
            } catch {
                errorWhileFetchingSearchedMeals = error
                isSearchedMealsLoading = false
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
        self.isMealsForCategoryLoading = true
        Task {
            do {
                mealsForSelectedCategory = try await GetMealsForCategoryUseCase(category: category).execute()
                isMealsForCategoryLoading = false
            } catch {
                errorWhileFetchingMealForCategory = error
                isMealsForCategoryLoading = false
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
