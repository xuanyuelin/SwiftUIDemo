//
//  TestView.swift
//  SwiftUIDemo
//
//  Created by gao lun on 2024/8/30.
//

import Foundation
import SwiftUI

struct TestView: HashableView {
    let key: String
    @Environment(\.navigator) var nav
    
    var id: String {
        String(describing: type(of: self)) + key
    }
    
    var body: some View {
        VStack {
            Text(key)
                .font(.system(size: 20))
            
            Spacer().frame(height: 20)
            
            RouterList { r in
                nav.push(view: r)
                print("xxx- apend: \(r), count: \(nav.path.count)")
            }
            
            Button(action: {
                let index = nav.path.count / 2
                nav.remove(at: index)
            }, label: {
                Text("RemoveMiddle!")
            })
            
            Button(action: {
                let index = nav.path.count
                nav.popBack(to: 0)
            }, label: {
                Text("PopToRoot!")
            })
        }
    }
}

#Preview {
    TestView(key: "djahdkaj")
}
