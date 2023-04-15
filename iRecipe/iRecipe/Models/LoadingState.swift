//
//  LoadingState.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

enum LoadingState<Content> {
    case initial
    case loading
    case error(Error)
    case loaded(Content)
}
