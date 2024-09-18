//
//  ContentView.swift
//  TicTacToe
//
//  Created by Erik Sebastian de Erice Jerez on 18/9/24.
//

import SwiftUI

struct ContentView: View {
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
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
                            isGameboardDisabled = true
                            
                            if checkWinCondition(for: .human, in: moves) {
                                print("Human wins")
                                return
                            }
                            
                            if checkForDraw(in: moves) {
                                print("Draw")
                                return
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer , boardIndex: computerPosition)
                                isGameboardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves) {
                                    print("Computer wins")
                                    return
                                }
                                
                                if checkForDraw(in: moves) {
                                    print("Draw")
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
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        moves.contains { $0?.boardIndex == index }
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
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
}

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
