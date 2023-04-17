//
//  MealDetails.swift
//  iRecipe
//
//  Created by Dumitru Manea on 16.04.2023.
//

import SwiftUI
import WebKit

struct MealDetails: View {
    @ObservedObject private var viewModel: MealDetailsViewModel
    
    init(viewModel: MealDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            switch viewModel.meal {
                case .initial, .loading:
                    ProgressView()
                case .loaded(let meal):
                    MealCardView(meal: meal) { mealId in
                        viewModel.setFavorite(mealId: mealId)
                    }
                    .overlay(alignment: .topLeading, content: {
                        if let area = meal.area {
                            areaOverlayText(with: area)
                        }
                    })
                    .overlay(alignment: .bottomTrailing, content: {
                        if let category = meal.category {
                            categoryOverlayText(with: category.rawValue)
                        }
                    })
                    
                    if let tags = meal.tags {
                        tagsView(with: tags)
                    }
                    
                    if let instructions = meal.instructions {
                        instructionsView(with: instructions)
                    }
                    
                    if let youtubeVideoUrlString = meal.youtube,
                       let youtubeVideoUrl = URL(string: youtubeVideoUrlString
                        .replacingOccurrences(of: Constants.MealDetails.youtubeUrlTextToReplace,
                                              with: Constants.MealDetails.youtubeUrlTextReplaceWith)) {
                        YoutubeVideoView(youtubeVideoUrl: youtubeVideoUrl)
                            .frame(height: 300)
                            .cornerRadius(Constants.General.cornerRadius)
                            .padding(Constants.General.padding)
                    }
                case .error(let error):
                    Text("\(Constants.MealDetails.errorMessage) \(error.localizedDescription)")
                        .font(.title2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.mealName)
    }
}

// MARK: - Componenets
private extension MealDetails {
    func areaOverlayText(with text: String) -> some View {
        Text(text)
            .padding([.leading, .top], Constants.General.padding)
            .foregroundColor(.white)
            .font(.title3)
            .shadow(color: .black, radius: 2)
    }
    
    func categoryOverlayText(with text: String) -> some View {
        Text(text)
            .padding([.leading, .top], Constants.General.padding)
            .foregroundColor(.white)
            .font(.title3)
            .shadow(color: .black, radius: 2)
    }
    
    func tagsView(with tags: String) -> some View {
        HStack {
            Text(Constants.MealDetails.tagsTitle)
                .foregroundColor(.teal)
            Text(tags.components(separatedBy: ",").joined(separator: ", "))
        }
        .frame(alignment: .leading)
        .font(.title3)
        .padding(Constants.General.padding)
    }
    
    @ViewBuilder
    var ingredientsAndMeasuresView: some View {
        LazyVGrid(columns: Constants.General.vGridColumns) {
            let ingredientsWithMeasures = viewModel.getFormattedIngredientsWithMeasures()
            ForEach(Array(ingredientsWithMeasures.keys.sorted()), id: \.self) { key in
                Group {
                    Text(key)
                    Text(ingredientsWithMeasures[key]!)
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(Constants.General.padding)
                .background(Color.white)
                .cornerRadius(Constants.General.cornerRadius)
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
            }
        }
        .padding([.leading, .trailing, .bottom], Constants.General.padding)
    }
    
    func instructionsView(with text: String) -> some View {
        Text(text)
            .font(.body)
            .padding()
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        MealDetails(viewModel: MealDetailsViewModel(meal: Mocks.meal))
    }
}
