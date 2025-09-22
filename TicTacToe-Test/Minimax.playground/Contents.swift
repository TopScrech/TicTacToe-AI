import Foundation

var board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]

func eval(_ board: [[String]]) -> Int {
    if playerHasWin("x", on: board) {
        return 1
    }
    
    if playerHasWin("o", on: board) {
        return -1
    }
    
    return 0
}

func printBoard(_ board: [[String]]) {
    for row in 0..<3 {
        print(" \(board[row][0]) | \(board[row][1]) | \(board[row][2]) ")
        
        if row < 2 {
            print("---+---+---")
        }
    }
    
    print("\n")
}

func findPossibleMoves(
    _ playerToMove: String,
    on board: [[String]]
) -> [[[String]]]? {
    
    var moves: [[[String]]] = []
    
    for row in 0..<board.count {
        for col in 0..<board[row].count {
            if board[row][col] == " " {
                var newBoard = board
                newBoard[row][col] = playerToMove
                
                moves.append(newBoard)
            }
        }
    }
    
    return moves
}

func isFull(_ board: [[String]]) -> Bool {
    !board.flatMap { $0 }.contains(" ")
}

func start(_ playerToMove: String, on board: [[String]]) {
    guard
        let possibleMoves = findPossibleMoves(playerToMove, on: board)
    else {
        return
    }
    
    for possibleMove in possibleMoves {
        print(printBoard(possibleMove))
        
        let eval = eval(possibleMove)
        
        if eval == 0, !isFull(possibleMove) {
            start(togglePlayer(playerToMove), on: possibleMove)
        } else {
            print(eval)
        }
    }
}

func togglePlayer(_ player: String) -> String {
    player == "x" ? "o" : "x"
}

let date1 = Date()

let startingBoard = [["x", " ", "o"], [" ", " ", " "], [" ", " ", " "]]
//let startingBoard = [["x", "o", "x"], ["x", "o", "o"], [" ", " ", " "]]
print("Starting position, x to move")

print(printBoard(startingBoard))
start("x", on: startingBoard)

let date2 = Date()
print("Time passed: \(date2.timeIntervalSince(date1)) seconds")

func playerHasWin(_ player: String, on board: [[String]]) -> Bool {
    for r in 0..<3 {
        if board[r][0] == player && board[r][1] == player && board[r][2] == player {
            return true
        }
    }
    
    for c in 0..<3 {
        if board[0][c] == player && board[1][c] == player && board[2][c] == player {
            return true
        }
    }
    
    if board[0][0] == player && board[1][1] == player && board[2][2] == player {
        return true
    }
    
    if board[0][2] == player && board[1][1] == player && board[2][0] == player {
        return true
    }
    
    return false
}
