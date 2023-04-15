//
//  TabBar.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct TabBar: View {
    @Binding private var selectedTab: TabBarTab
    @State private var tabBarButtonsPoints: [CGFloat] = []
    
    init(selectedTab: Binding<TabBarTab>) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(currentTab: .home, selectedTab: $selectedTab, tabBarButtonsPoints: $tabBarButtonsPoints)
            TabBarButton(currentTab: .randomRecipe, selectedTab: $selectedTab, tabBarButtonsPoints: $tabBarButtonsPoints)
            TabBarButton(currentTab: .favoriteRecipes, selectedTab: $selectedTab, tabBarButtonsPoints: $tabBarButtonsPoints)
        }
        .padding()
        .background(
            Color.white
                .clipShape(TabCurve(tabPoint: getCurvePoint() - 15))
        )
        .overlay(
            Circle()
                .fill(.teal)
                .frame(width: 10, height: 10)
                .offset(x: getCurvePoint() - 20)
            , alignment: .bottomLeading
        )
        .cornerRadius(30)
        .padding(.horizontal)
    }
}

// MARK: - Private methods
private extension TabBar {
    func getCurvePoint() -> CGFloat {
        guard tabBarButtonsPoints.isNotEmpty else { return 10 }
        guard let indexOfTab = TabBarTab.allCases.firstIndex(of: selectedTab)
        else { fatalError("Inconsistency of tabs") }
        return tabBarButtonsPoints[indexOfTab]
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedTab: .constant(.home))
    }
}
