//
//  TicTacToeView.swift
//  TicTacToe
//
//  Created by Erik Sebastian de Erice Jerez on 18/9/24.
//

import SwiftUI

struct TicTacToeView: View {
    @StateObject private var vm = TicTacToeViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: vm.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Square(proxy: geometry)
                            Icon(name: vm.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            vm.processPlayerMove(for: i)
                        }
                    }
                }
                
                Spacer()
            }
            .disabled(vm.isGameboardDisabled)
            .padding()
            .alert(item: $vm.alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.buttonTitle, action: vm.reset)
                )
            }
        }
    }
}

#Preview {
    TicTacToeView()
}
