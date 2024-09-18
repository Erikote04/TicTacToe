//
//  ContentView.swift
//  TicTacToe
//
//  Created by Erik Sebastian de Erice Jerez on 18/9/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Properties
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled: Bool = false
    @State private var alertItem: AlertItem?
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    // MARK: View
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundStyle(.red).opacity(0.5)
                                .frame(
                                    width: geometry.size.width / 3 - 15,
                                    height: geometry.size.width / 3 - 15
                                )
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human , boardIndex: i)
                            
                            if checkWinCondition(for: .human, in: moves) {
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if checkForDraw(in: moves) {
                                alertItem = AlertContext.draw
                                return
                            }
                            
                            isGameboardDisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer , boardIndex: computerPosition)
                                isGameboardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves) {
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                
                                if checkForDraw(in: moves) {
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .disabled(isGameboardDisabled)
            .padding()
            .alert(item: $alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.buttonTitle, action: reset)
                )
            }
        }
    }
    
    // MARK: Functions
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        moves.contains(where: { $0?.boardIndex == index })
    }
    
    /**
     determineComputerMovePosition(in moves: [Move?]) -> Int
     - parameter moves: game board
     - returns: the chosen square
     - description: If AI can win, then win -> If AI can't win, then block -> If AI can't block, then take middle square -> If AI can't take middle square, take random available square.
     */
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // horizontal
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // vertical
            [0, 4, 8], [2, 4, 6]             // diagonal
        ]
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't block, then take middle square
        let middleSquare = 4
        if !isSquareOccupied(in: moves, forIndex: middleSquare) {
            return middleSquare
        }
        
        // If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // horizontal
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // vertical
            [0, 4, 8], [2, 4, 6]             // diagonal
        ]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPosition = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        moves.compactMap { $0 }.count == 9
    }
    
    func reset() {
        moves = Array(repeating: nil, count: 9)
    }
}

// MARK: Model

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

#Preview {
    ContentView()
}
