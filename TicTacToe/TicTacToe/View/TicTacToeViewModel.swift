//
//  TicTacToeViewModel.swift
//  TicTacToe
//
//  Created by Erik Sebastian de Erice Jerez on 19/9/24.
//

import SwiftUI

final class TicTacToeViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled: Bool = false
    @Published var alertItem: AlertItem?
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    // MARK: Public Functions
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human , boardIndex: position)
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
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
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        if let winningMove = findWinningMove(for: .computer, in: moves) {
            return winningMove
        }

        if let blockingMove = findBlockingMove(for: .human, in: moves) {
            return blockingMove
        }

        if let middleMove = takeMiddleSquare(in: moves) {
            return middleMove
        }

        return chooseRandomAvailableSquare(in: moves)
    }

    
    func findWinningMove(for player: Player, in moves: [Move?]) -> Int? {
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })

        for pattern in winPatterns {
            let winPositions = pattern.subtracting(playerPositions)
            
            if winPositions.count == 1, let position = winPositions.first {
                if !isSquareOccupied(in: moves, forIndex: position) {
                    return position
                }
            }
        }
        
        return nil
    }

    func findBlockingMove(for opponent: Player, in moves: [Move?]) -> Int? {
        return findWinningMove(for: opponent, in: moves)
    }

    func takeMiddleSquare(in moves: [Move?]) -> Int? {
        let middleSquare = 4
        
        if !isSquareOccupied(in: moves, forIndex: middleSquare) {
            return middleSquare
        }
        
        return nil
    }

    func chooseRandomAvailableSquare(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
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
