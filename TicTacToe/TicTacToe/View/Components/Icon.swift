//
//  Icon.swift
//  TicTacToe
//
//  Created by Erik Sebastian de Erice Jerez on 19/9/24.
//

import SwiftUI

struct Icon: View {
    var name: String
    
    var body: some View {
        Image(systemName: name)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundStyle(.white)
    }
}
