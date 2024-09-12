//
//  PageCoordinate.swift
//  SwiftUIDemo
//
//  Created by gao lun on 2024/9/4.
//

import Foundation
import ComposableArchitecture
import TCACoordinators
import SwiftUI

@Reducer
struct TestReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        let index: Int
        var selected: String
        
        var id: String {
            "\(index)\n\(selected)"
        }
    }
    
    enum Action {
        case setSelected(String) // push
        case popBack
        case popCount(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setSelected(s):
                state.selected = s
                return .none
            default:
                return .none
            }
        }
    }
}

struct TCATestView: HashableView {
    let store: StoreOf<TestReducer>
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("TCA sub at: \(store.index), \(store.selected)")
                
            Spacer().frame(height: 50)
            
            Button("Push") {
                store.send(.setSelected(UUID().uuidString))
            }
            
            Spacer()
        }
        .backGray()
        .overlay(alignment: .bottom) {
            VStack {
                Button("dimiss") {
                    dismiss()
                }
                Button("popBack") {
                    store.send(.popBack)
                }
                Button("popBack2") {
                    store.send(.popCount(2))
                }
            }
        }
    }
}

@Reducer
struct RootReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: String = "Root"
    }
    
    enum Action {
        case pushTest
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .pushTest:
                return .none
            }
        }
    }
}

struct TCARootView: HashableView {
    let store: StoreOf<RootReducer>
    @Environment(\.dismiss) var dismiss
    @State private var on = false
    var body: some View {
        ZStack {
            Color.white
                .onTapGesture {
                    store.send(.pushTest)
                }
            
            Text("TCA root.")
        }
        .overlay(alignment: .bottom) {
            Button("dimiss") {
                dismiss()
            }
        }
    }
}

@Reducer(state: .equatable)
enum Page {
    case root(RootReducer)
    case test(TestReducer)
}

@Reducer
struct PageCoordinate {
    
    @ObservableState
    struct State {
        var pages: [Route<Page.State>] = []
    }
    
    enum Action {
        case router(IndexedRouterActionOf<Page>)
    }
    
    var body: some ReducerOf<Self> {
      Reduce { state, action in
          switch action {
          case let .router(.routeAction(idx, .root(.pushTest))):
              state.pages.push(.test(.init(index: idx, selected: "pushed by root")))
              
          case let .router(.routeAction(idx, .test(.setSelected(s)))):
              state.pages.push(.test(.init(index: idx, selected: s)))
              
          case let .router(.routeAction(_, .test(.popBack))):
              state.pages.removeLast(1)
              
          case let .router(.routeAction(_, .test(.popCount(count)))):
              state.pages.removeLast(count)
          
          default:
              break
          }
          return .none
      }
      .forEachRoute(\.pages, action: \.router)
    }
}

struct PageCoordinateView: View {
    let store: StoreOf<PageCoordinate>
    
    var body: some View {
        TCARouter(store.scope(state: \.pages, action: \.router)) { screen in
          switch screen.case {
          case let .root(store):
              TCARootView(store: store)
          case let .test(store):
              TCATestView(store: store)
          }
        }
    }
}

