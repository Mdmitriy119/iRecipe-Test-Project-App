//
//  SearchTextField.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct SearchTextField: View {
    @Binding private var searchText: String
    
    init(searchText: Binding<String>) {
        self._searchText = searchText
    }
    
    var body: some View {
        TextField("Type your meal", text: $searchText)
            .textFieldStyle(.plain)
            .padding()
            .background(Color.lightGray)
            .cornerRadius(16)
            .shadow(color: .black, radius: 2)
            .accentColor(Color.teal)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.webSearch)
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
            )
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(searchText: .constant(""))
    }
}
