//
//  RecipeDetailsViewModel.swift
//  iRecipe
//
//  Created by Dumitru Manea on 16.04.2023.
//

import Foundation

protocol RecipeDetailsViewModelServicing {
    var meal: Meal { get }
}

struct RecipeDetailsViewModel: RecipeDetailsViewModelServicing {
    let meal: Meal
    
    init(meal: Meal) {
        self.meal = meal
    }
}
