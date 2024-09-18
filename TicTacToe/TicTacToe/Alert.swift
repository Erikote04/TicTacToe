//
//  Alert.swift
//  TicTacToe
//
//  Created by Erik Sebastian de Erice Jerez on 18/9/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(
        title: Text("You Win!"),
        message: Text("Congratulations, AI is not going to take your job."),
        buttonTitle: Text("Win Again")
    )
    
    static let computerWin = AlertItem(
        title: Text("You Lost"),
        message: Text("AI is going to take your job."),
        buttonTitle: Text("Rematch")
    )
    
    static let draw = AlertItem(
        title: Text("Draw"),
        message: Text("You both are the best duo"),
        buttonTitle: Text("Try Again")
    )
}
