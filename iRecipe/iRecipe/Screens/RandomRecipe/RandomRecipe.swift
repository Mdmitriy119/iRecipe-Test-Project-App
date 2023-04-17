//
//  RandomRecipe.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct RandomRecipe: View {
    @ObservedObject private var viewModel: RandomRecipeViewModel
    
    init(viewModel: RandomRecipeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        header
                            .padding()
                        content
                            .padding(.horizontal)
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
                .navigationTitle("Random Recipe")
            }
        }
    }
}

// MARK: - Sub-components
private extension RandomRecipe {
    @ViewBuilder
    var header: some View {
        HStack {
            Spacer()
            Text("Tap one more time on tab bar button to see another recipe!")
                .font(.title2)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    @ViewBuilder
    var content: some View {
        switch viewModel.meal {
            case .initial, .loading:
                ProgressView()
            case .loaded(let meal):
                NavigationLink(
                    destination: RecipeDetails(viewModel: RecipeDetailsViewModel(meal: meal))) {
                        MealView(meal: meal) { mealId in
                            viewModel.setFavorite(mealId: mealId)
                        }
                    }
            case .error(let error):
                Text("Error fetching random meal: \(error.localizedDescription)")
                    .font(.title2)
        }
    }
}

struct RandomRecipe_Previews: PreviewProvider {
    static var previews: some View {
        RandomRecipe(viewModel: RandomRecipeViewModel())
    }
}
