import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameManager()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        VStack(spacing: 24) {
            Text("Tic Tac Toe")
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)

            Text("Current Player: \(game.currentPlayer.rawValue)")
                .font(.title3)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<9, id: \.self) { index in
                    cellButton(index: index)
                }
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Button(action: {
                withAnimation(.spring()) {
                    game.resetGame()
                }
            }) {
                Text("Reset")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding()
        .alert(game.alertTitle, isPresented: $game.gameOver) {
            Button("Reset") { game.resetGame() }
            Button("OK") { }
        }
        .animation(.easeInOut, value: game.board)
    }

    @ViewBuilder
    private func cellButton(index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                game.makeMove(at: index)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(radius: 3)

                Text(game.board[index])
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(game.board[index] == "X" ? .blue : .red)
                    .transition(.scale)
            }
            .frame(height: 90)
        }
        .disabled(!game.board[index].isEmpty || game.gameOver)
    }
}
