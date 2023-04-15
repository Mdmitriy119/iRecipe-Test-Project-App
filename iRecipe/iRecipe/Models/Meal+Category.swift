//
//  Meal+Category.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

extension Meal {
    struct Category: Decodable {
        enum Name: String, Decodable {
//            case beef = "Beef"
//            case chicken = "Chicken"
//            case dessert = "Dessert"
//            case lamb = "Lamb"
//            case miscellaneous = "Miscellaneous"
//            case pasta = "Pasta"
//            case pork = "Pork"
//            case seafood = "Seafood"
//            case side = "Side"
//            case starter = "Starter"
//            case vegan = "Vegan"
//            case vegetarian = "Vegetarian"
//            case breakfast = "Breakfast"
//            case goat = "Goat"
            
            case beef
            case chicken
            case dessert
            case lamb
            case miscellaneous
            case pasta
            case pork
            case seafood
            case side
            case starter
            case vegan
            case vegetarian
            case breakfast
            case goat
            
            var rawValue: String {
                let stringValue = "\(self)"
                return stringValue.prefix(1).uppercased() + stringValue.dropFirst()
            }
        }
        
        let id: String
        let name: Name
        let thumbnail: String
        let description: String
    }
}
