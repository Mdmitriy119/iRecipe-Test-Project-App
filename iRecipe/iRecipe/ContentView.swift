//
//  ContentView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabBarTab = .home
    
    var body: some View {
        ZStack(alignment: .bottom){
            switch selectedTab {
                case .home:
                    Home()
                case .randomRecipe:
                    RandomRecipe()
                case .favoriteRecipes:
                    FavoriteRecipes()
            }
            
            TabBar(selectedTab: $selectedTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
