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
        TextField(Constants.SearchTextField.placeholder, text: $searchText)
            .textFieldStyle(.plain)
            .padding(Constants.General.padding)
            .background(Color.lightGray)
            .cornerRadius(Constants.General.cornerRadius)
            .shadow(color: .black, radius: 2)
            .accentColor(Color.teal)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.webSearch)
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: Constants.SearchTextField.searchIconName)
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
