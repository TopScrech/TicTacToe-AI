import Foundation

var board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]

func hasWin(_ board: [[String]]) -> Int {
    if playerHasWin("x", on: board) {
        return 1
    }
    
    if playerHasWin("o", on: board) {
        return -1
    }
    
    return 0
}

print(hasWin([[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]))
print(hasWin([["x", "x", "x"], [" ", " ", " "], [" ", " ", " "]]))
print(hasWin([[" ", " ", " "], ["x", "x", "x"], [" ", " ", " "]]))
print(hasWin([[" ", " ", " "], [" ", " ", " "], ["x", "x", "x"]]))
print(hasWin([["x", " ", " "], [" ", "x", " "], [" ", " ", "x"]]))
print(hasWin([[" ", " ", "x"], [" ", "x", " "], ["x", " ", " "]]))
print(hasWin([["x", " ", " "], ["x", " ", " "], ["x", " ", " "]]))
print(hasWin([["x", " ", " "], ["x", " ", " "], ["x", " ", " "]]))
print(hasWin([["o", " ", " "], ["o", " ", " "], ["o", " ", " "]]))

//func hasWin(_ board: [[String]]) -> Bool {
//    if playerHasWin("x", on: board) || playerHasWin("o", on: board) {
//        true
//    } else {
//        false
//    }
//}
//
//print(playerHasWin("x", on: [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]))
//print(playerHasWin("x", on: [["x", "x", "x"], [" ", " ", " "], [" ", " ", " "]]))
//print(playerHasWin("x", on: [[" ", " ", " "], ["x", "x", "x"], [" ", " ", " "]]))
//print(playerHasWin("x", on: [[" ", " ", " "], [" ", " ", " "], ["x", "x", "x"]]))
//print(playerHasWin("x", on: [["x", " ", " "], [" ", "x", " "], [" ", " ", "x"]]))
//print(playerHasWin("x", on: [[" ", " ", "x"], [" ", "x", " "], ["x", " ", " "]]))
//print(playerHasWin("x", on: [["x", " ", " "], ["x", " ", " "], ["x", " ", " "]]))
//print(playerHasWin("o", on: [["x", " ", " "], ["x", " ", " "], ["x", " ", " "]]))
//print(playerHasWin("x", on: [["o", " ", " "], ["o", " ", " "], ["o", " ", " "]]))
//
//print("\n")
//
//print(hasWin([[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]))
//print(hasWin([["x", "x", "x"], [" ", " ", " "], [" ", " ", " "]]))
//print(hasWin([[" ", " ", " "], ["x", "x", "x"], [" ", " ", " "]]))
//print(hasWin([[" ", " ", " "], [" ", " ", " "], ["x", "x", "x"]]))
//print(hasWin([["x", " ", " "], [" ", "x", " "], [" ", " ", "x"]]))
//print(hasWin([[" ", " ", "x"], [" ", "x", " "], ["x", " ", " "]]))
//print(hasWin([["x", " ", " "], ["x", " ", " "], ["x", " ", " "]]))
//print(hasWin([["x", " ", " "], ["x", " ", " "], ["x", " ", " "]]))
//print(hasWin([["o", " ", " "], ["o", " ", " "], ["o", " ", " "]]))

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
