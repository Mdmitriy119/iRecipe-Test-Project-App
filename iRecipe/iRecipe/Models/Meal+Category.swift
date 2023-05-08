//
//  Meal+Category.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

extension Meal {
    struct Category: Decodable, Identifiable {
        enum Name: String, Decodable {
            case beef = "Beef"
            case chicken = "Chicken"
            case dessert = "Dessert"
            case lamb = "Lamb"
            case miscellaneous = "Miscellaneous"
            case pasta = "Pasta"
            case pork = "Pork"
            case seafood = "Seafood"
            case side = "Side"
            case starter = "Starter"
            case vegan = "Vegan"
            case vegetarian = "Vegetarian"
            case breakfast = "Breakfast"
            case goat = "Goat"
        }
        
        let id: String
        let name: Name
        let thumbnail: String
        let description: String
    }
}

// MARK: - Conding keys
private extension Meal.Category {
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbnail = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}

// MARK: - Equatable
extension Meal.Category: Equatable {
    static func ==(lhs: Meal.Category, rhs: Meal.Category) -> Bool {
        return lhs.id == rhs.id
    }
}
