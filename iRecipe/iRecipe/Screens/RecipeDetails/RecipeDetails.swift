//
//  RecipeDetails.swift
//  iRecipe
//
//  Created by Dumitru Manea on 16.04.2023.
//

import SwiftUI

struct RecipeDetails: View {
    @ObservedObject private var viewModel: RecipeDetailsViewModel
    
    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            switch viewModel.meal {
                case .initial, .loading:
                    ProgressView()
                case .loaded(let meal):
                    MealView(meal: meal) { mealId in
                        viewModel.setFavorite(mealId: mealId)
                    }
                    if let instructions = meal.instructions {
                        Text(instructions)
                            .font(.body)
                            .padding()
                    }
                case .error(let error):
                    Text("Error fetching meal details: \(error.localizedDescription)")
                        .font(.title2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.mealName)
    }
}

// MARK: - Sub-components
private extension RecipeDetails {
    
}

struct StickyHeader<Content: View>: View {
    
    var minHeight: CGFloat
    var content: Content
    
    init(minHeight: CGFloat = 200, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geo in
            if(geo.frame(in: .global).minY <= 0) {
                content
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            } else {
                content
                    .offset(y: -geo.frame(in: .global).minY)
                    .frame(width: geo.size.width, height: geo.size.height + geo.frame(in: .global).minY)
            }
        }.frame(minHeight: minHeight)
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(viewModel: RecipeDetailsViewModel(meal: Meal.mockMeal))
    }
}
