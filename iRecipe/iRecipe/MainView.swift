//
//  MainView.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Home(viewModel: HomeViewModel())
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            RandomRecipe()
                .tabItem {
                    Label("Random Recipe", systemImage: "arrow.triangle.2.circlepath.circle")
                }
            Home(viewModel: HomeViewModel())
                .tabItem {
                    Label("Home", systemImage: "heart")
                }
        }
        .accentColor(.teal)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
