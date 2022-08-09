//
//  BackgroundImageView.swift
//  MyToDoList
//
//  Created by marco rodriguez on 08/08/22.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("todolist")
            .antialiased(true)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(.all)
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
