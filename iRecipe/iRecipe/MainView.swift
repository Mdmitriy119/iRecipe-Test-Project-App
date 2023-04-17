//
//  MainView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @ObservedObject private var homeViewModel: HomeViewModel
    @ObservedObject private var randomMealViewModel: RandomMealViewModel
    @ObservedObject private var favoriteMealsViewModel: FavoriteMealsViewModel
    
    init(homeViewModel: HomeViewModel,
         randomMealViewModel: RandomMealViewModel,
         favoriteMealsViewModel: FavoriteMealsViewModel) {
        self.homeViewModel = homeViewModel
        self.randomMealViewModel = randomMealViewModel
        self.favoriteMealsViewModel = favoriteMealsViewModel
    }
    
    
    var body: some View {
        let tabViewSelectionBinding = Binding(
            get: { self.selectedTab },
            set: {
                self.selectedTab = $0
                if selectedTab == 1 {
                    // Re-fetch another meal
                    randomMealViewModel.reconnect()
                }
            }
        )
        
        TabView(selection: tabViewSelectionBinding) {
            Home(viewModel: homeViewModel)
                .tabItem {
                    Label(Constants.MainView.homeTabItemName,
                          systemImage: Constants.MainView.homeTabItemIconName)
                }
                .tag(0)
            RandomMeal(viewModel: randomMealViewModel)
                .tabItem {
                    Label(Constants.MainView.randomMealTabItemName,
                          systemImage: Constants.MainView.randomMealTabItemIconName)
                }
                .tag(1)
            FavoriteMeals(viewModel: favoriteMealsViewModel)
                .tabItem {
                    Label(Constants.MainView.favoriteMealsTabItemName,
                          systemImage: Constants.MainView.favoriteMealsTabItemIconName)
                }
                .tag(2)
        }
        .accentColor(.teal)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(homeViewModel: HomeViewModel(),
                 randomMealViewModel: RandomMealViewModel(),
                 favoriteMealsViewModel: FavoriteMealsViewModel())
    }
}
