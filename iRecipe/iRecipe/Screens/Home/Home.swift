//
//  Home.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct Home: View {
    @ObservedObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                header
                content
            }
            .navigationTitle(Constants.Home.navigationTitle)
        }
        .onAppear {
            viewModel.refreshMealsIfNeeded()
        }
    }
}

// MARK: - Components
private extension Home {
    @ViewBuilder
    var header: some View {
        Group {
            HStack {
                Text(Constants.Home.searchBarPlaceholder)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
            }
            SearchTextField(searchText: $viewModel.searchText)
        }
        .padding([.leading, .trailing, .bottom], Constants.General.padding)
    }
    
    @ViewBuilder
    var content: some View {
        searchedMealsView
            .padding([.leading, .trailing, .bottom], Constants.General.padding)
        allMealsCategoriesView
            .padding([.leading, .trailing, .bottom], Constants.General.padding)
        mealsForSelectedCategoryView
            .padding([.leading, .trailing, .bottom], Constants.General.padding)
    }
    
    @ViewBuilder
    var searchedMealsView: some View {
        switch viewModel.searchedMeals {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let meals):
                LazyVGrid(columns: Constants.General.vGridColumns) {
                    ForEach(meals) { meal in
                        NavigationLink(
                            destination: MealDetails(viewModel: MealDetailsViewModel(meal: meal))) {
                                MealCardView(meal: meal) { mealId in
                                    viewModel.setFavorite(mealId: mealId)
                                }
                            }
                    }
                }
            case .error:
                if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty {
                    HStack {
                        Text("\(Constants.Home.noSearchedMealsErrorMessage) \(viewModel.searchText)")
                            .font(.title2)
                        Spacer()
                    }
                }
        }
    }
    
    @ViewBuilder
    var allMealsCategoriesView: some View {
        switch viewModel.mealsCategories {
            case .initial, .loading:
                ProgressView()
            case .loaded(let categories):
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories) { category in
                            MealCategoryView(currentCategory: category,
                                         selectedCategory: $viewModel.selectedCategory)
                        }
                    }
                }
            default:
                EmptyView()
        }
    }
    
    @ViewBuilder
    var mealsForSelectedCategoryView: some View {
        switch viewModel.mealsBySelectedCategory {
            case .initial, .loading:
                ProgressView()
            case .loaded(let meals):
                LazyVGrid(columns: Constants.General.vGridColumns) {
                    ForEach(meals) { meal in
                        NavigationLink(
                            destination: MealDetails(
                                viewModel: MealDetailsViewModel(
                                    meal: meal,
                                    shouldFetchMealDetails: true))) {
                            MealCardView(meal: meal) { mealId in
                                viewModel.setFavorite(mealId: mealId)
                            }
                        }
                    }
                }
            default:
                EmptyView()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewModel: HomeViewModel())
    }
}
