//
//  Home.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct Home: View {
    @ObservedObject private var viewModel: HomeViewModel
        
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    HStack {
                        Text("What meal are you searching for?")
                            .font(.title2)
                        Spacer()
                    }
                    SearchTextField(searchText: $viewModel.searchText)
                }
                .padding(.horizontal, 20)
                
                mealsCategoriesContent
                    .padding(.top, 16)
            }
            .navigationTitle("Home")
        }
    }
    
    @ViewBuilder
    private var mealsCategoriesContent: some View {
        switch viewModel.mealsCategories {
            case .loading:
                ProgressView()
            case .loaded(let categories):
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(categories) { category in
                            CategoryView(currentCategory: category, selectedCategory: $viewModel.selectedCategory)
                        }
                    }
                }
            default:
                EmptyView()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(viewModel: HomeViewModel())
    }
}
