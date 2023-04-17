//
//  ObservedObject.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct RandomMeal: View {
    @ObservedObject private var viewModel: RandomMealViewModel
    
    init(viewModel: RandomMealViewModel) {
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
                }
            }
            .navigationTitle("Random Recipe")
        }
    }
}

// MARK: - Sub-components
private extension RandomMeal {
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
                    destination: MealDetails(viewModel: MealDetailsViewModel(meal: meal))) {
                        MealCardView(meal: meal) { mealId in
                            viewModel.setFavorite(mealId: mealId)
                        }
                    }
            case .error(let error):
                Text("Error fetching random meal: \(error.localizedDescription)")
                    .font(.title2)
        }
    }
}

struct RandomMeal_Previews: PreviewProvider {
    static var previews: some View {
        RandomMeal(viewModel: RandomMealViewModel())
    }
}
