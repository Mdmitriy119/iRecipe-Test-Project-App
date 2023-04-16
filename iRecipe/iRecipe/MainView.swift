//
//  MainView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct MainView: View {
    // MARK: - Private properties
    @State private var selectedTab = 0
    @ObservedObject private var homeViewModel: HomeViewModel
    @ObservedObject private var randomRecipeViewModel: RandomRecipeViewModel
    @ObservedObject private var favoriteRecipesViewModel: FavoriteRecipesViewModel
    
    init(homeViewModel: HomeViewModel,
         randomRecipeViewModel: RandomRecipeViewModel,
         favoriteRecipesViewModel: FavoriteRecipesViewModel) {
        self.homeViewModel = homeViewModel
        self.randomRecipeViewModel = randomRecipeViewModel
        self.favoriteRecipesViewModel = favoriteRecipesViewModel
    }
    
    
    var body: some View {
        let tabViewSelectionBinding = Binding(
            get: { self.selectedTab },
            set: {
                self.selectedTab = $0
                if selectedTab == 1 {
                    // Re-fetch another meal
                    randomRecipeViewModel.reconnect()
                }
            })
        
        TabView(selection: tabViewSelectionBinding) {
            Home(viewModel: homeViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            RandomRecipe(viewModel: randomRecipeViewModel)
                .tabItem {
                    Label("Random Recipe", systemImage: "arrow.triangle.2.circlepath.circle")
                }
                .tag(1)
            FavoriteRecipes(viewModel: favoriteRecipesViewModel)
                .tabItem {
                    Label("Favorite Recipes", systemImage: "heart")
                }
                .tag(2)
        }
        .accentColor(.teal)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(homeViewModel: HomeViewModel(),
                 randomRecipeViewModel: RandomRecipeViewModel(),
                 favoriteRecipesViewModel: FavoriteRecipesViewModel())
    }
}
