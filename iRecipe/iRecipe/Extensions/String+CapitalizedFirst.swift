//
//  String+CapitalizedFirst.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

extension String {
    var capitalizedFirst: String {
        return prefix(1).capitalized + dropFirst()
    }
}
