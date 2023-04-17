//
//  RecipeDetails.swift
//  iRecipe
//
//  Created by Dumitru Manea on 16.04.2023.
//

import SwiftUI

struct RecipeDetails: View {
    private let viewModel: RecipeDetailsViewModel
    
    init(viewModel: RecipeDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            mealCardView
            mealInstructions
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - Sub-components
private extension RecipeDetails {
    @ViewBuilder
    private var mealCardView: some View {
        MealView(meal: viewModel.meal) { mealId in
            print("Here: \(mealId)")
        }
    }
    
    @ViewBuilder
    private var mealInstructions: some View {
        if let instructions = viewModel.meal.instructions {
            Text(instructions)
                .font(.title3)
                .padding()
        }
    }
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
