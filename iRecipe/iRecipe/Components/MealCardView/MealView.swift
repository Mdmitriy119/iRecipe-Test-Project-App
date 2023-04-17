//
//  MealCardView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct MealCardView: View {
    private var meal: Meal
    private let onFavoriteButtonTapped: (_ mealId: String) -> ()
    
    init(meal: Meal, onFavoriteButtonTapped: @escaping (_ mealId: String) -> (Void)) {
        self.meal = meal
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let mealStringUrl = meal.thumbnail {
                CacheAsyncImage(url: URL(string: mealStringUrl)!) { phase in
                    switch phase {
                        case .success(let image):
                            image.resizable()
                        default:
                            Color.lightGray
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
                            .foregroundColor(meal.isFavorite ? .pink : .white)
                            .padding([.top, .trailing])
                    }
                })
            }
        }
        .frame(maxWidth: .infinity)
        .shadow(color: .black, radius: 2)
    }
}

struct MealCardView_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewModel: HomeViewModel())
    }
}
