//
//  Meal.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

struct Meal: Decodable, Identifiable {
    let id: String
    let name: String
    let category: Category.Name?
    let area: String?
    let instructions: String?
    let thumbnail: String?
    let tags: String?
    let youtube: String?
    let ingredient1: String?
    let ingredient2: String?
    let ingredient3: String?
    let ingredient4: String?
    let ingredient5: String?
    let ingredient6: String?
    let ingredient7: String?
    let ingredient8: String?
    let ingredient9: String?
    let ingredient10: String?
    let ingredient11: String?
    let ingredient12: String?
    let ingredient13: String?
    let ingredient14: String?
    let ingredient15: String?
    let ingredient16: String?
    let ingredient17: String?
    let ingredient18: String?
    let ingredient19: String?
    let ingredient20: String?
    let measure1: String?
    let measure2: String?
    let measure3: String?
    let measure4: String?
    let measure5: String?
    let measure6: String?
    let measure7: String?
    let measure8: String?
    let measure9: String?
    let measure10: String?
    let measure11: String?
    let measure12: String?
    let measure13: String?
    let measure14: String?
    let measure15: String?
    let measure16: String?
    let measure17: String?
    let measure18: String?
    let measure19: String?
    let measure20: String?
    var isFavorite: Bool = false
}

// MARK: - Coding keys
private extension Meal {
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
        case tags = "strTags"
        case youtube = "strYoutube"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"
        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
        case measure16 = "strMeasure16"
        case measure17 = "strMeasure17"
        case measure18 = "strMeasure18"
        case measure19 = "strMeasure19"
        case measure20 = "strMeasure20"
    }
}

extension Meal {
    static let mockMeal = Meal(
        id: "52772",
        name: "Teriyaki Chicken Casserole",
        category: .chicken,
        area: "Japanese",
        instructions: """
Preheat oven to 350° F. Spray a 9x13-inch baking pan with non-stick spray.
Combine soy sauce, ½ cup water, brown sugar, ginger and garlic in a small saucepan and cover. Bring to a boil over medium heat. Remove lid and cook for one minute once boiling.
Meanwhile, stir together the corn starch and 2 tablespoons of water in a separate dish until smooth. Once sauce is boiling, add mixture to the saucepan and stir to combine. Cook until the sauce starts to thicken then remove from heat.
Place the chicken breasts in the prepared pan. Pour one cup of the sauce over top of chicken. Place chicken in oven and bake 35 minutes or until cooked through. Remove from oven and shred chicken in the dish using two forks.
*Meanwhile, steam or cook the vegetables according to package directions.
Add the cooked vegetables and rice to the casserole dish with the chicken. Add most of the remaining sauce, reserving a bit to drizzle over the top when serving. Gently toss everything together in the casserole dish until combined. Return to oven and cook 15 minutes. Remove from oven and let stand 5 minutes before serving. Drizzle each serving with remaining sauce. Enjoy!
""",
        thumbnail: "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg",
        tags: "Meat,Casserole",
        youtube: "https://www.youtube.com/watch?v=4aZr5hZXP_s",
        ingredient1: "soy sauce",
        ingredient2: "water",
        ingredient3: "brown sugar",
        ingredient4: "ground ginger",
        ingredient5: "minced garlic",
        ingredient6: "cornstarch",
        ingredient7: "chicken breasts",
        ingredient8: "stir-fry vegetables",
        ingredient9: "brown rice",
        ingredient10: "",
        ingredient11: "",
        ingredient12: "",
        ingredient13: "",
        ingredient14: "",
        ingredient15: "",
        ingredient16: nil,
        ingredient17: nil,
        ingredient18: nil,
        ingredient19: nil,
        ingredient20: nil,
        measure1: "3/4 cup",
        measure2: "1/2 cup",
        measure3: "1/4 cup",
        measure4: "1/2 teaspoon",
        measure5: "1/2 teaspoon",
        measure6: "4 Tablespoons",
        measure7: "2",
        measure8: "1 (12 oz.)",
        measure9: "3 cups",
        measure10: "",
        measure11: "",
        measure12: "",
        measure13: "",
        measure14: "",
        measure15: "",
        measure16: nil,
        measure17: nil,
        measure18: nil,
        measure19: nil,
        measure20: nil)
}

