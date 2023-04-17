//
//  Home.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct Home: View {
    @ObservedObject private var viewModel: HomeViewModel
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                header
                content
            }
            .navigationTitle("Home")
        }
        .onAppear {
            viewModel.refreshMealsIfNeeded()
        }
    }
}

// MARK: - Header
private extension Home {
    @ViewBuilder
    var header: some View {
        Group {
            HStack {
                Text("What meal are you searching for?")
                    .font(.title2)
                Spacer()
            }
            SearchTextField(searchText: $viewModel.searchText)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Content
private extension Home {
    @ViewBuilder
    var content: some View {
        searchedMealsView
            .padding()
        allMealsCategoriesView
            .padding()
        mealsForSelectedCategoryView
            .padding([.leading, .trailing, .bottom])
    }
    
    @ViewBuilder
    var searchedMealsView: some View {
        switch viewModel.searchedMeals {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case .loaded(let meals):
                LazyVGrid(columns: columns) {
                    ForEach(meals) { meal in
                        NavigationLink(
                            destination: RecipeDetails(viewModel: RecipeDetailsViewModel(meal: meal))) {
                                MealView(meal: meal) { mealId in
                                    viewModel.setFavorite(mealId: mealId)
                                }
                            }
                    }
                }
            case .error:
                if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty {
                    HStack {
                        Text("There are no meals which contains: \(viewModel.searchText)")
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
                            CategoryView(currentCategory: category, selectedCategory: $viewModel.selectedCategory)
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
                LazyVGrid(columns: columns) {
                    ForEach(meals) { meal in
                        NavigationLink(
                            destination: RecipeDetails(viewModel: RecipeDetailsViewModel(meal: meal))) {
                                MealView(meal: meal) { mealId in
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
