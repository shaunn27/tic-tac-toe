import SwiftUI

final class GameManager: ObservableObject {
    enum Player: String {
        case x = "X"
        case o = "O"

        var next: Player { self == .x ? .o : .x }
    }

    @Published var board: [String] = Array(repeating: "", count: 9)
    @Published var currentPlayer: Player = .x
    @Published var gameOver: Bool = false
    @Published var alertTitle: String = ""

    func makeMove(at index: Int) {
        guard !gameOver, board[index].isEmpty else { return }

        board[index] = currentPlayer.rawValue

        if checkWin(for: currentPlayer.rawValue) {
            gameOver = true
            alertTitle = "\(currentPlayer.rawValue) Wins!"
        } else if board.allSatisfy({ !$0.isEmpty }) {
            gameOver = true
            alertTitle = "It's a Draw!"
        } else {
            currentPlayer = currentPlayer.next
        }
    }

    func resetGame() {
        board = Array(repeating: "", count: 9)
        currentPlayer = .x
        gameOver = false
        alertTitle = ""
    }

    private func checkWin(for symbol: String) -> Bool {
        let wins = [
            [0,1,2],[3,4,5],[6,7,8],
            [0,3,6],[1,4,7],[2,5,8],
            [0,4,8],[2,4,6]
        ]
        return wins.contains { $0.allSatisfy { board[$0] == symbol } }
    }
}
