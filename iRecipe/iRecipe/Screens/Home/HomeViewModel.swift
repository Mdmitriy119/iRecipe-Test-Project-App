//
//  HomeViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation
import Combine

protocol HomeViewModelServicing: ObservableObject {
    var searchText: String { get set }
    var searchedMeals: LoadingState<[Meal]> { get }
    var selectedCategory: Meal.Category? { get set }
    var mealsCategories: LoadingState<[Meal.Category]> { get }
    var mealsForCategory: LoadingState<[Meal]> { get }
}

final class HomeViewModel: HomeViewModelServicing {
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Public properties
    @Published var searchText: String = ""
    @Published var searchedMeals: LoadingState<[Meal]>
    @Published var selectedCategory: Meal.Category?
    @Published var mealsCategories: LoadingState<[Meal.Category]>
    @Published var mealsForCategory: LoadingState<[Meal]>
    
    init() {
        mealsCategories = .initial
        searchedMeals = .loaded([])
        mealsForCategory = .initial
        connect()
    }
}

// MARK: - Public methods
extension HomeViewModel {
    func connect() {
        listenForMealCategoryChange()
        listenForSearchTextChange()
        
        Task {
            await fetchMealsCategories()
            setDefaultSelectedCategory()
        }
    }
}

// MARK: - Private methods
private extension HomeViewModel {
    func listenForMealCategoryChange() {
        $selectedCategory
            .sink { mealCategory in
                guard let mealCategory else { return }
                Task {
                    await self.fetchMeals(for: mealCategory)
                }
            }
            .store(in: &subscriptions)
    }
    
    func fetchMeals(for category: Meal.Category) async {
//        self.mealsForCategory = .initial
        do {
            let meals = try await GetMealsByCategoryUseCase(category: category).execute()
            DispatchQueue.main.async {
                self.mealsForCategory = .loaded(meals)
            }
        } catch {
            DispatchQueue.main.async {
                self.mealsForCategory = .error(error)
            }
        }
        
    }
    
    func listenForSearchTextChange() {
        $searchText
            .sink { mealName in
                let mealName = mealName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard mealName.isNotEmpty else { return }
                Task {
                    await self.fetchMeals(for: mealName)
                }
            }
            .store(in: &subscriptions)
    }
    
    func fetchMeals(for mealName: String) async {
//        self.searchedMeals = .loading
        do {
            let meals = try await GetSearchedMealsUseCase(searchedMealName: mealName).execute()
            DispatchQueue.main.async {
                self.searchedMeals = .loaded(meals)
            }
        } catch {
            DispatchQueue.main.async {
                self.searchedMeals = .error(error)
            }
        }
    }
    
    func fetchMealsCategories() async {
//        self.mealsCategories = .loading
        do {
            let mealsCategories = try await GetMealsCategoriesUseCase().execute()
            DispatchQueue.main.async {
                self.mealsCategories = .loaded(mealsCategories)
            }
        } catch {
            DispatchQueue.main.async {
                self.mealsCategories = .error(error)
            }
        }
    }
    
    func setDefaultSelectedCategory() {
        if case let .loaded(mealsCategories) = mealsCategories {
            selectedCategory = mealsCategories.first
        }
    }
}
