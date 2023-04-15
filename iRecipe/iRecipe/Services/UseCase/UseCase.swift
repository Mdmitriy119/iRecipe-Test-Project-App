//
//  UseCase.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import Foundation

protocol UseCase {
    associatedtype Output
    
    func execute() async throws -> Output
}
