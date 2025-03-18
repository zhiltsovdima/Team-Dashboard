//
//  TabBarItemView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 17.03.2025.
//

import SwiftUI

struct TabBarItemView: View {
    let model: TabBarItem
    let style: TabBarStyle
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: model.icon)
                .resizable()
                .scaledToFit()
                .frame(width: style.iconSize, height: style.iconSize)
                .foregroundColor(
                    isSelected ? style.activeColor : style.inactiveColor
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
            
            Text(model.title)
                .font(style.font)
                .foregroundColor(
                    isSelected ? style.activeColor : style.inactiveColor
                )
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
        .animation(
            .easeInOut(duration: 0.2), value: isSelected
        )
    }
}

#Preview {
    TabBarItemView(
        model: .dashboard,
        style: .default,
        isSelected: true,
        action: {}
    )
}
