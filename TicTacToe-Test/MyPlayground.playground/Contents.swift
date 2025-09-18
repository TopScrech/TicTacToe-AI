import Foundation

var isWin = false
var board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]

printBoard(board)

moveRandom("x")
printBoard(board)

moveRandom("o")
printBoard(board)

moveRandom("x")
printBoard(board)

moveRandom("o")
printBoard(board)

moveRandom("x")
printBoard(board)

moveRandom("o")
printBoard(board)

moveRandom("x")
printBoard(board)

moveRandom("o")
printBoard(board)

moveRandom("x")
printBoard(board)

func printBoard(_ board: [[String]]) {
    print("\(board[0])\n\(board[1])\n\(board[2])")
}

@MainActor
func moveRandom(_ move: String) {
    guard !isWin(move) else {
        print("Finished")
        return
    }
    
    let randomRow = Int.random(in: 0...2)
    let randomColumn = Int.random(in: 0...2)
    
    if board[randomRow][randomColumn] == " " {
        board[randomRow][randomColumn] = move
    } else {
        moveRandom(move)
    }
    
    print(isWin(move))
}

@MainActor
func isWin(_ move: String) -> Bool {
    // Rows
    for row in 0..<3 {
        if board[row][0] == move && board[row][1] == move && board[row][2] == move {
            return true
        }
    }
    
    // Columns
    for col in 0..<3 {
        if board[0][col] == move && board[1][col] == move && board[2][col] == move {
            return true
        }
    }
    
    // Diagonals
    if board[0][0] == move && board[1][1] == move && board[2][2] == move {
        return true
    }
    
    if board[0][2] == move && board[1][1] == move && board[2][0] == move {
        return true
    }
    
    return false
}
