//
//  MealView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct MealView: View {
    private let meal: Meal
    
    init(meal: Meal) {
        self.meal = meal
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let mealStringUrl = meal.thumbnail {
                AsyncImage(url: URL(string: mealStringUrl)) { image in
                    image.resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } placeholder: {
                    Color.lightGray
                }
                .overlay(alignment: .bottomLeading, content: {
                    Text(meal.name)
                        .padding([.leading,. bottom])
                        .foregroundColor(.white)
                        .font(.title2)
                })
                .overlay(alignment: .topTrailing, content: {
                    Image(systemName: "heart")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding([.top, .trailing])
                })
            }
        }
        .shadow(color: .black, radius: 2)
        .padding()
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView(meal: Meal.mockMeal)
    }
}
