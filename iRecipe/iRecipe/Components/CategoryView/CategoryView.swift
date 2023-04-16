//
//  CategoryView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct CategoryView: View {
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
                AsyncImage(url: URL(string: currentCategory.thumbnail)) { image in
                    image.resizable()
                } placeholder: {
                    backgroundColor
                }
                .frame(width: 40, height: 40)
                .aspectRatio(1.6, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding()
            .background(
                backgroundColor
                    .cornerRadius(16)
            )
        }
    }
    
    @ViewBuilder
    private var backgroundColor: some View {
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
