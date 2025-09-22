import Foundation

var board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
var gameOver = false

func printBoard(_ board: [[String]]) {
    for row in 0..<3 {
        print(" \(board[row][0]) | \(board[row][1]) | \(board[row][2]) ")
        
        if row < 2 {
            print("---+---+---")
        }
    }
    
    print("\n")
}

@MainActor
func isFull() -> Bool {
    !board.flatMap { $0 }.contains(" ")
}

@MainActor
func hasWin(_ move: String) -> Bool {
    for r in 0..<3 {
        if board[r][0] == move && board[r][1] == move && board[r][2] == move {
            return true
        }
    }
    
    for c in 0..<3 {
        if board[0][c] == move && board[1][c] == move && board[2][c] == move {
            return true
        }
    }
    
    if board[0][0] == move && board[1][1] == move && board[2][2] == move {
        return true
    }
    
    if board[0][2] == move && board[1][1] == move && board[2][0] == move {
        return true
    }
    
    return false
}

@MainActor
func moveRandom(_ move: String) {
    guard !gameOver else {
        return
    }
    
    guard !isFull() else {
        gameOver = true
        print("Finished")
        
        return
    }
    
    let r = Int.random(in: 0...2)
    let c = Int.random(in: 0...2)
    
    if board[r][c] == " " {
        board[r][c] = move
        printBoard(board)
        
        if hasWin(move) {
            gameOver = true
            print(move.uppercased(), "wins")
            
            return
        }
        
        if isFull() {
            gameOver = true
            print("Tie")
            
            return
        }
    } else {
        moveRandom(move)
    }
}

var current = "x"

@MainActor
func play(_ times: Int) {
    for _ in 0...times-1 {
        while !gameOver {
            moveRandom(current)
            current = (current == "x") ? "o" : "x"
        }
        
        gameOver = false
        board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
    }
}

play(1)
