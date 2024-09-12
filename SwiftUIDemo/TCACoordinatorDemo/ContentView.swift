//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by gao lun on 2024/8/30.
//

import SwiftUI
import ComposableArchitecture

enum Router: String, Hashable, CaseIterable {
    case a
    case b
    case c
}

class Navigator: ObservableObject {
//    static let shared = Navigator()
//    private init() {}
    
    @Published var path = NavigationPath()
    private var routes: [AnyHashable] = []
    
    func push<V>(view: V) where V: Hashable {
        path.append(view)
        routes.append(view)
    }
    
    func popBack(to index: Int) {
        guard index < routes.count - 1 else { return }
        path.removeLast(routes.count - 1 - index)
        routes = Array(routes[0 ... index])
    }
    
    func remove(at index: Int) {
        guard index < routes.count else { return }
        routes.remove(at: index)
        
        path.removeLast(path.count)
        for r in routes {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.path.append(r) // not support deep link
            }
        }
    }
}



extension EnvironmentValues {
    private struct NavigatorKey: EnvironmentKey {
        static let defaultValue = Navigator()
    }
    
    var navigator: Navigator {
        get { self[NavigatorKey.self] }
        set { self[NavigatorKey.self] = newValue }
    }
}

struct ContentView: View {
    @StateObject private var nav = Navigator()
    @State private var showTCA: Bool = false
    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack(spacing: 0) {
                Text("Root!")
                    .font(.system(size: 20))
                
                Spacer().frame(height: 20)
                
                RouterList { r in
                    nav.push(view: r)
                    print("xxx- root apend: \(r), count: \(nav.path.count)")
                }
                
                Spacer().frame(height: 50)
                
                Button("TCA") {
                    showTCA = true
                }
            }
            .navigationDestination(for: Router.self) { r in
                TestView(key: r.rawValue)
            }
            .fullScreenCover(isPresented: $showTCA) {
                PageCoordinateView(
                    store: Store(initialState: PageCoordinate.State(
                        pages: [.cover(.root(.init()), embedInNavigationView: true)]
                    ), reducer: {
                        PageCoordinate()
                    })
                )
            }
        }
        .environment(\.navigator, nav)
    }
}

struct RouterList: View {
    let onTap: (Router) -> Void
    
    var body: some View {
        List {
            ForEach(Router.allCases, id: \.self) { r in
                Text(r.rawValue)
                    .font(.system(size: 14))
                    .frame(height: 20)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: 0xFFFFFF, alpha: 0.01))
                    .onTapGesture {
                        onTap(r)
                    }
            }
            .listRowSeparator(.hidden)
        }
    }
}

#Preview {
    ContentView()
}
