//
//  FavoriteRecipes.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct FavoriteRecipes: View {
    @ObservedObject private var viewModel: FavoriteRecipesViewModel
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
    
    init(viewModel: FavoriteRecipesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                content
                    .padding()
            }
            .navigationTitle("Favorite Recipes")
        }
        .onAppear {
            viewModel.connect()
        }
    }
}

// MARK: - Sub-components
private extension FavoriteRecipes {
    @ViewBuilder
    var content: some View {
        switch viewModel.favoriteMeals {
            case .initial:
                ProgressView()
            case .loaded(let meals):
                let favoriteMeals = meals.filter { $0.isFavorite }
                LazyVGrid(columns: columns) {
                    ForEach(favoriteMeals) { meal in
                        MealView(meal: meal) { mealId in
                            viewModel.setFavorite(mealId: mealId)
                        }
                    }
                }
            default:
                EmptyView()
        }
    }
}

struct FavoriteRecipes_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRecipes(viewModel: FavoriteRecipesViewModel())
    }
}
