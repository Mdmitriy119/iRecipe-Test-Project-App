//
//  MealCardView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct MealCardView: View {
    @Binding private var meal: Meal
    
    init(meal: Binding<Meal>) {
        self._meal = meal
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
                .clipShape(RoundedRectangle(cornerRadius: Constants.General.cornerRadius))
                .overlay(alignment: .bottomLeading, content: {
                    Text(meal.name)
                        .padding([.leading,. bottom, .trailing], Constants.General.padding)
                        .foregroundColor(.white)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                })
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        PreferenceService.Meals.setFavorite(mealId: meal.id)
                        meal.isFavorite.toggle()
                    } label: {
                        Image(systemName: meal.isFavorite ? "\(Constants.MealView.favoriteIcoName).fill" : Constants.MealView.favoriteIcoName)
                            .font(.title2)
                            .foregroundColor(meal.isFavorite ? .pink : .white)
                            .padding([.top, .trailing], Constants.General.padding)
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
