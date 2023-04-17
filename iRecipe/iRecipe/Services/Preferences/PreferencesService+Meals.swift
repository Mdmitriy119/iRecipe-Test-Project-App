//
//  PreferencesService+Meals.swift
//  iRecipe
//
//  Created by Dumitru Manea on 17.04.2023.
//

import Foundation

extension PreferenceService {
    struct Meals {
        @Storage(key: "favoriteMealsIds", defaultValue: [])
        static var favoriteIds: [String]
        
        static func setFavorite(mealId: String) {
            if let index = favoriteIds.firstIndex(of: mealId) {
                favoriteIds.remove(at: index)
            } else {
                favoriteIds.append(mealId)
            }
        }
    }
}
