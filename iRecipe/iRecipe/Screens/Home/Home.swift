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
                Text(Constants.Home.headerTitle)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
        if viewModel.isSearchedMealsLoading {
            ProgressView()
        } else if let _ = viewModel.errorWhileFetchingSearchedMeals {
            if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isNotEmpty {
                HStack {
                    Text("\(Constants.Home.noSearchedMealsErrorMessage) \(viewModel.searchText)")
                        .font(.title2)
                    Spacer()
                }
            }
        } else {
            if viewModel.searchedMeals.isNotEmpty {
                LazyVGrid(columns: Constants.General.vGridColumns) {
                    ForEach(0..<viewModel.searchedMeals.count, id: \.self) { index in
                        NavigationLink(destination: MealDetails(viewModel: MealDetailsViewModel(meal: $viewModel.searchedMeals[index]))) {
                            MealCardView(meal:  $viewModel.searchedMeals[index])
                        }
                    }
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
        if viewModel.isMealsForCategoryLoading {
            ProgressView()
        } else if let _ = viewModel.errorWhileFetchingMealForCategory {
            EmptyView()
        } else {
            LazyVGrid(columns: Constants.General.vGridColumns) {
                ForEach(0..<viewModel.mealsForSelectedCategory.count, id: \.self) { index in
                    NavigationLink(destination: MealDetails(viewModel: MealDetailsViewModel(meal: $viewModel.mealsForSelectedCategory[index],
                                                                                            shouldFetchMealDetails: true))) {
                        MealCardView(meal: $viewModel.mealsForSelectedCategory[index])
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewModel: HomeViewModel())
    }
}
