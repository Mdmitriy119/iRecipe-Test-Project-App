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
        allMealsCategories
            .padding()
        mealsBySelectedCategory
            .padding([.leading, .trailing, .bottom])
    }
    
    @ViewBuilder
    var allMealsCategories: some View {
        switch viewModel.mealsCategories {
            case .loading:
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
    var mealsBySelectedCategory: some View {
        switch viewModel.mealsBySelectedCategory {
            case .loading:
                ProgressView()
            case .loaded(let meals):
                LazyVGrid(columns: columns) {
                    ForEach(meals) { meals in
                        MealView(meal: meals)
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
