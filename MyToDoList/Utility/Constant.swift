//
//  Constant.swift
//  MyToDoList
//
//  Created by marco rodriguez on 02/08/22.
//

import SwiftUI

 let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// MARK: - UI
var backgroundGradient: LinearGradient {
    return LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
}
