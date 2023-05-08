//
//  Constants+UseCases.swift
//  iRecipe
//
//  Created by Dumitru Manea on 17.04.2023.
//

import Foundation

extension Constants {
    enum UseCases {
        static let categoriesEndpoint = "https://www.themealdb.com/api/json/v1/1/categories.php"
        static let categoriesKey = "categories"
        static let searchEnpoint = "https://www.themealdb.com/api/json/v1/1/search.php?s="
        static let mealsKey = "meals"
        static let mealsForCategoryEndpoint = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
        static let randomEndpoint = "https://www.themealdb.com/api/json/v1/1/random.php"
        static let mealByIdUseCase = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    }
}
