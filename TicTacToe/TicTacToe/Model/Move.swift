//
//  Move.swift
//  TicTacToe
//
//  Created by Erik Sebastian de Erice Jerez on 19/9/24.
//

import SwiftUI

enum Player {
    case human
    case computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
