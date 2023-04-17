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
    
    func refreshMealsIfNeeded()
    func setFavorite(mealId: String)
}

@MainActor final class HomeViewModel: HomeViewModelServicing {
    @Storage(key: "favoriteMealsIds", defaultValue: [])
    private var favoriteMealsIds: [String]
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Public properties
    @Published var searchText: String = ""
    @Published var searchedMeals: LoadingState<[Meal]>
    @Published var selectedCategory: Meal.Category?
    @Published var mealsCategories: LoadingState<[Meal.Category]>
    @Published var mealsBySelectedCategory: LoadingState<[Meal]>
    
    init() {
        mealsCategories = .initial
        searchedMeals = .initial
        mealsBySelectedCategory = .initial
        connect()
    }
}

// MARK: - Public methods
extension HomeViewModel {
    /// Refresh meals when these were marked fav/no fav from different screens
    func refreshMealsIfNeeded() {
        // Searched meals
        if case .loaded(var meals) = searchedMeals {
            let favoriteMealsIds = Set(favoriteMealsIds)
            for index in 0..<meals.count {
                meals[index].isFavorite = favoriteMealsIds.contains(meals[index].id)
            }
            self.searchedMeals = .loaded(meals)
        }
        
        
        // Meals by category
        if case .loaded(var meals) = mealsBySelectedCategory {
            let favoriteMealsIds = Set(favoriteMealsIds)
            for index in 0..<meals.count {
                meals[index].isFavorite = favoriteMealsIds.contains(meals[index].id)
            }
            self.mealsBySelectedCategory = .loaded(meals)
        }
    }
    
    func setFavorite(mealId: String) {
        if let index = favoriteMealsIds.firstIndex(of: mealId) {
            favoriteMealsIds.remove(at: index)
        } else {
            favoriteMealsIds.append(mealId)
        }
        
        if case .loaded(let meals) = searchedMeals {
            let adaptedMeals = markMealsFavoriteIfNeeded(meals: meals)
            self.searchedMeals = .loaded(adaptedMeals)
        }
        
        if case .loaded(let meals) = mealsBySelectedCategory {
            let adaptedMeals = markMealsFavoriteIfNeeded(meals: meals)
            self.mealsBySelectedCategory = .loaded(adaptedMeals)
        }
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
                    self?.searchedMeals = .initial
                    return
                }
                self?.fetchMeals(for: searchText)
            }
            .store(in: &subscriptions)
    }
    
    func fetchMeals(for searchText: String) {
        self.searchedMeals = .loading
        
        Task {
            do {
                let meals = try await GetSearchedMealsUseCase(searchText: searchText).execute()
                let adaptedMeals = markMealsFavoriteIfNeeded(meals: meals)
                self.searchedMeals = .loaded(adaptedMeals)
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
                let meals = try await GetMealsForCategoryUseCase(category: category).execute()
                let adaptedMeals = markMealsFavoriteIfNeeded(meals: meals)
                self.mealsBySelectedCategory = .loaded(adaptedMeals)
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
    
    func markMealsFavoriteIfNeeded(meals: [Meal]) -> [Meal] {
        var meals = meals
        let favoriteMealsIds = Set(favoriteMealsIds)
        for index in 0..<meals.count {
            meals[index].isFavorite = favoriteMealsIds.contains(meals[index].id)
        }
        let sortedMeals = meals.sorted(by: { $0.id < $1.id })
        
        return sortedMeals
    }
}
