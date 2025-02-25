//
//  AppSettings.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import Foundation

struct AppInfo {
    static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Urban Guide"
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
}
