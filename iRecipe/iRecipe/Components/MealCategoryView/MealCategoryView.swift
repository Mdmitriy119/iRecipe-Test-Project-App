//
//  MealCategoryView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct MealCategoryView: View {
    private let currentCategory: Meal.Category
    @Binding private var selectedCategory: Meal.Category?
    
    init(currentCategory: Meal.Category, selectedCategory: Binding<Meal.Category?>) {
        self.currentCategory = currentCategory
        self._selectedCategory = selectedCategory
    }
    
    var body: some View {
        Button {
            selectedCategory = currentCategory
        } label: {
            HStack(spacing: 4) {
                Text(currentCategory.name.rawValue)
                    .font(.title2)
                    .foregroundColor(.black)
                CacheAsyncImage(url: URL(string: currentCategory.thumbnail)!) { phase in
                    switch phase {
                        case .success(let image):
                            image.resizable()
                        default:
                            backgroundColor
                    }
                }
                .frame(width: Constants.MealCategoryView.categoryImageSize,
                       height: Constants.MealCategoryView.categoryImageSize)
                .aspectRatio(1.6, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: Constants.General.cornerRadius))
            }
            .padding()
            .background(
                backgroundColor.cornerRadius(Constants.General.cornerRadius)
            )
        }
    }
}

// MARK: - Components
private extension MealCategoryView {
    @ViewBuilder
    var backgroundColor: some View {
        if currentCategory == selectedCategory {
            Color.teal
        } else {
            Color.lightGray
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
       Home(viewModel: HomeViewModel())
    }
}
