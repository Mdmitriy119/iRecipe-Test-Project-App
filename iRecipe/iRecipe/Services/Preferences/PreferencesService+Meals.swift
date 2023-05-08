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
        
        static func markMealsAsFavoriteIfNeeded(meals: [Meal]) -> [Meal] {
            var meals = meals
            for index in 0..<meals.count {
                meals[index].isFavorite = favoriteIds.contains(meals[index].id)
            }
            let sortedMeals = meals.sorted(by: { $0.id < $1.id })
            return sortedMeals
        }
        
        static func markMealAsFavoriteIfNeeded(meal: Meal) -> Meal {
            var meal = meal
            meal.isFavorite = favoriteIds.contains(meal.id)
            return meal
        }
    }
}
