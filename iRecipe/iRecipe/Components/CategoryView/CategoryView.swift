//
//  CategoryView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct CategoryView: View {
    private let category: Meal.Category
    
    init(category: Meal.Category) {
        self.category = category
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(category.name.rawValue)
                .font(.title2)
            
            AsyncImage(url: URL(string: category.thumbnail)) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(1.6, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } placeholder: {
                Color.lightGray
            }
        }
        .padding()
        .background(
            Color.lightGray
                .cornerRadius(16)
        )
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let mockCategory = Meal.Category(
            id: "1",
            name: .beef,
            thumbnail: "https://www.themealdb.com/images/category/beef.png",
            description: "Beef is the culinary name for meat from cattle, particularly skeletal muscle. Humans have been eating beef since prehistoric times.[1] Beef is a source of high-quality protein and essential nutrients.[2]")
        CategoryView(category: mockCategory)
    }
}
