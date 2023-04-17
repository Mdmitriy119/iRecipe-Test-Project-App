//
//  FavoriteMeals.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct FavoriteMeals: View {
    @ObservedObject private var viewModel: FavoriteMealsViewModel
    
    init(viewModel: FavoriteMealsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                content
                    .padding(Constants.General.padding)
            }
            .navigationTitle(Constants.FavoriteMeals.navigationTitle)
        }
        .onAppear {
            // We should fetch onAppear always fav meals
            viewModel.connect()
        }
    }
}

// MARK: - Components
private extension FavoriteMeals {
    @ViewBuilder
    var content: some View {
        switch viewModel.favoriteMeals {
            case .initial, .loading:
                ProgressView()
            case .loaded(let meals):
                LazyVGrid(columns: Constants.General.vGridColumns) {
                    ForEach(meals) { meal in
                        NavigationLink(
                            destination: MealDetails(viewModel: MealDetailsViewModel(meal: meal))) {
                                MealCardView(meal: meal) { mealId in
                                    viewModel.removeFavorite(mealId: mealId)
                                }
                            }
                    }
                }
            default:
                EmptyView()
        }
    }
}

struct FavoriteMeals_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMeals(viewModel: FavoriteMealsViewModel())
    }
}
