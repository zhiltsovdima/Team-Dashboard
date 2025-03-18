//
//  TabBarStyle.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 17.03.2025.
//

import SwiftUI

struct TabBarStyle {
    let activeColor: Color
    let inactiveColor: Color
    let backgroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let iconSize: CGFloat
    let font: Font
}

extension TabBarStyle {
    static let `default` = TabBarStyle(
        activeColor: .blue,
        inactiveColor: .gray,
        backgroundColor: .white,
        borderColor: .black.opacity(0.2),
        borderWidth: 1,
        iconSize: 24,
        font: .system(size: 12, weight: .medium)
    )
}
