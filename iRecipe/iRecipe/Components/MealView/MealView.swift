//
//  MealView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct MealView: View {
    private var meal: Meal
    private let onFavoriteButtonTapped: (_ mealId: String) -> ()
    
    init(meal: Meal, onFavoriteButtonTapped: @escaping (_ mealId: String) -> (Void)) {
        self.meal = meal
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let mealStringUrl = meal.thumbnail {
                AsyncImage(url: URL(string: mealStringUrl)) { image in
                    image.resizable()
                } placeholder: {
                    Color.lightGray
                }
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(alignment: .bottomLeading, content: {
                    Text(meal.name)
                        .padding([.leading,. bottom])
                        .foregroundColor(.white)
                        .font(.title3)
                })
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        onFavoriteButtonTapped(meal.id)
                    } label: {
                        Image(systemName: meal.isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding([.top, .trailing])
                    }
                })
            }
        }
        .frame(maxWidth: .infinity)
        .shadow(color: .black, radius: 2)
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewModel: HomeViewModel())
    }
}
