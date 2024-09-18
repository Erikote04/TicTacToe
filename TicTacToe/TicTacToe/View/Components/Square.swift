//
//  Square.swift
//  TicTacToe
//
//  Created by Erik Sebastian de Erice Jerez on 19/9/24.
//

import SwiftUI

struct Square: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundStyle(.red).opacity(0.5)
            .frame(
                width: proxy.size.width / 3 - 15,
                height: proxy.size.width / 3 - 15
            )
    }
}
