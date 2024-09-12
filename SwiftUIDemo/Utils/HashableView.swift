//
//  HashableView.swift
//  Dazi
//
//  Created by gao lun on 2024/3/25.
//

import Foundation
import SwiftUI

protocol HashableView: View, Hashable {
    var id: String { get }
}

extension HashableView {
    var id: String {
        String(describing: type(of: self))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
