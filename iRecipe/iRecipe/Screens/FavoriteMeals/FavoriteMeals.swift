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
        if viewModel.isFavoriteMealsLoading {
            ProgressView()
        } else if let error = viewModel.errorWhileFetchingFavoriteMeals {
            Text("\(Constants.FavoriteMeals.errorMessage) \(error.localizedDescription)")
                .font(.title2)
        } else {
            LazyVGrid(columns: Constants.General.vGridColumns) {
                ForEach($viewModel.favoriteMeals) { $meal in
                    NavigationLink(destination: MealDetails(viewModel: MealDetailsViewModel(meal: $meal))) {
                        MealCardView(meal: $meal)
                    }
                }
            }
        }
    }
}

struct FavoriteMeals_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMeals(viewModel: FavoriteMealsViewModel())
    }
}
