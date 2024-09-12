//
//  SwiftUIDemoApp.swift
//  SwiftUIDemo
//
//  Created by gao lun on 2024/8/30.
//

import SwiftUI

@main
struct SwiftUIDemoApp: App {
    var body: some Scene {
        WindowGroup {
            DemoRootView()
        }
    }
}

enum DemoPage: String, CaseIterable {
    case TCACoordinator
    case Gesture
    
    @ViewBuilder var body: some View {
        switch self {
        case .TCACoordinator:
            ContentView()
        case .Gesture:
            GDView()
        }
    }
}

struct DemoRootView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(DemoPage.allCases, id: \.self) { page in
                        NavigationLink(page.rawValue) {
                            page.body
                        }
                    }
                }
            }
        }
    }
}
