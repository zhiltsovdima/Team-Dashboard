//
//  MetricView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 26.03.2025.
//

import SwiftUI

struct MetricView: View {
    let title: String
    let value: Int
    
    var body: some View {
        Text("\(title): \(value)")
            .font(.system(size: 18, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
    }
}

#Preview {
    MetricView(title: "Title", value: 5)
}
