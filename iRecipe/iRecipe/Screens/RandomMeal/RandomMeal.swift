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
                            .padding(Constants.General.padding)
                        content
                            .padding(.horizontal, Constants.General.padding)
                    }
                }
            }
            .navigationTitle(Constants.RandomMeal.navigationTitle)
        }
    }
}

// MARK: - Components
private extension RandomMeal {
    @ViewBuilder
    var header: some View {
        HStack {
            Spacer()
            Text(Constants.RandomMeal.headerTitle)
                .font(.title2)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.isMealLoading {
            ProgressView()
        } else if let error = viewModel.errorWhileFetchingMeal {
            Text("\(Constants.RandomMeal.errorMessage) \(error.localizedDescription)")
                .font(.title2)
        } else {
            // If there is no error and data is no loading, we have meal for sure
            NavigationLink(destination: MealDetails(viewModel: MealDetailsViewModel(meal: Binding($viewModel.meal)!))) {
                MealCardView(meal: Binding($viewModel.meal)!)
            }
        }
    }
}

struct RandomMeal_Previews: PreviewProvider {
    static var previews: some View {
        RandomMeal(viewModel: RandomMealViewModel())
    }
}
