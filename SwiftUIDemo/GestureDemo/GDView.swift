//
//  GDView.swift
//  SwiftUIDemo
//
//  Created by gao lun on 2024/9/12.
//

import Foundation
import SwiftUI

struct GDFatherView: View {
    var body: some View {
        Color.red
            .onTapGesture {
                print("tap father!")
            }
            .overlay {
                GDChildView()
                    .padding(50)
            }
    }
}

struct GDChildView: View {
    var body: some View {
        Color.orange
            .onTapGesture {
                print("tap child!")
            }
    }
}

struct GDTestView1: View {
    var body: some View {
        Color.orange
            .frame(width: 200, height: 200)
            .onTapGesture {
                print("a")
            }
            .gesture(
                TapGesture()
                    .onEnded {
                        print("b")
                    }
            )
    }
}

struct GDTestView2: View {
    var body: some View {
        Color.orange
            .frame(width: 200, height: 200)
            .onTapGesture {
                print("a")
            }
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        print("b")
                    }
            )
    }
}

struct GDTestView3: View {
    var body: some View {
        Color.orange
            .frame(width: 200, height: 200)
            .onTapGesture {
                print("a")
            }
            .highPriorityGesture(
                TapGesture()
                    .onEnded {
                        print("b")
                    }
            )
    }
}

struct GDView: View {
    var body: some View {
        List {
            ForEach(0 ... 3, id: \.self) { i in
                NavigationLink("\(i)") {
                    switch i {
                    case 0: GDFatherView()
                    case 1: GDTestView1()
                    case 2: GDTestView2()
                    case 3: GDTestView3()
                    default: EmptyView()
                    }
                }
            }
        }
    }
}
