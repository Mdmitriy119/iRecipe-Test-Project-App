//
//  TabBarButton.swift
//  iRecipe
//
//  Created by Dumitru Manea on 15.04.2023.
//

import SwiftUI

struct TabBarButton: View {
    private let currentTab: TabBarTab
    @Binding private var selectedTab: TabBarTab
    @Binding private var tabBarButtonsPoints: [CGFloat]

    init(currentTab: TabBarTab, selectedTab: Binding<TabBarTab>, tabBarButtonsPoints: Binding<[CGFloat]>) {
        self.currentTab = currentTab
        self._selectedTab = selectedTab
        self._tabBarButtonsPoints = tabBarButtonsPoints
    }
    
    var body: some View {
        GeometryReader { geometry -> AnyView in
            let midX = geometry.frame(in: .global).midX
            
            DispatchQueue.main.async {
                if tabBarButtonsPoints.count < TabBarTab.allCases.count {
                    tabBarButtonsPoints.append(midX)
                }
            }
            
            return AnyView(barButtonitem)
        }
        .frame(height: 35)
    }
    
    @ViewBuilder
    private var barButtonitem: some View {
        Button {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5)) {
                selectedTab = currentTab
            }
        } label: {
            Image(systemName: "\(currentTab.rawValue)\(currentTab == selectedTab ? ".fill" : "")")
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.teal)
                .offset(y: selectedTab == currentTab ? -10 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedTab: .constant(.favoriteRecipes))
    }
}
