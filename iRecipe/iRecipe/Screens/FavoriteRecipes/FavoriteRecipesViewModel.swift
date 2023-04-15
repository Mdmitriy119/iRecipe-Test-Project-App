//
//  FavoriteRecipesViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation
import Combine

@MainActor final class FavoriteRecipesViewModelServicing: ObservableObject {
    var favoriteMeals: 
}

@MainActor final class FavoriteRecipesViewModel: FavoriteRecipesViewModelServicing {
    @Storage(key: "favoriteMeals", defaultValue: [])
    private var favoriteMeals: [String]
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        
    }
}
