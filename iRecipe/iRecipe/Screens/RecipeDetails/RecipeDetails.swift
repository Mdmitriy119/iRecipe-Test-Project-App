//
//  RecipeDetails.swift
//  iRecipe
//
//  Created by Dumitru Manea on 16.04.2023.
//

import SwiftUI
import WebKit

struct RecipeDetails: View {
    @ObservedObject private var viewModel: RecipeDetailsViewModel
    private let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
    
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
                    .overlay(alignment: .topLeading, content: {
                        if let area = meal.area {
                            Text(area)
                                .padding([.leading, .top])
                                .foregroundColor(.white)
                                .font(.title3)
                                .shadow(color: .black, radius: 2)
                        }
                    })
                    .overlay(alignment: .bottomTrailing, content: {
                        if let category = meal.category {
                            Text(category.rawValue)
                                .padding([.trailing, .bottom])
                                .foregroundColor(.white)
                                .font(.title3)
                                .shadow(color: .black, radius: 2)
                        }
                    })
                    
                    HStack {
                        if let tags = meal.tags {
                            Text("Tags:")
                                .foregroundColor(.teal)
                            Text(tags.components(separatedBy: ",").joined(separator: ", "))
                        }
                    }
                    .frame(alignment: .leading)
                    .font(.title3)
                    .padding()
                    
                    LazyVGrid(columns: columns) {
                        let ingredientsWithMeasures = viewModel.getFormattedIngredientsWithMeasures()
                        ForEach(Array(ingredientsWithMeasures.keys.sorted()), id: \.self) { key in
                            Group {
                                Text(key)
                                Text(ingredientsWithMeasures[key]!)
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                    
                    
                    if let instructions = meal.instructions {
                        Text(instructions)
                            .font(.body)
                            .padding()
                    }
                    
                    if let youtubeVideoUrlString = meal.youtube,
                       let youtubeVideoUrl = URL(string: youtubeVideoUrlString.replacingOccurrences(of: "watch?v=", with: "embed/")) {
                        YoutubeVideoView(youtubeVideoUrl: youtubeVideoUrl)
                            .frame(height: 300)
                            .cornerRadius(16)
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

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(viewModel: RecipeDetailsViewModel(meal: Mocks.meal))
    }
}
