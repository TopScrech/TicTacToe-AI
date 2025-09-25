import Foundation

func isFull(_ board: [[String]]) -> Bool {
    !board.flatMap { $0 }.contains(" ")
}

func togglePlayer(_ player: String) -> String {
    player == "x" ? "o" : "x"
}

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
        print("", board[row][0], "|", board[row][1], "|", board[row][2], "")
        
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

func buildTree(_ playerToMove: String, on board: [[String]]) -> GameTree {
    let value = eval(board)
    
    if value != 0 || isFull(board) {
        return GameTree(board: board, eval: value, subtrees: [])
    }
    
    guard
        let possibleMoves = findPossibleMoves(playerToMove, on: board),
        !possibleMoves.isEmpty
    else {
        return GameTree(board: board, eval: value, subtrees: [])
    }
    
    let next = possibleMoves.map { move in
        buildTree(togglePlayer(playerToMove), on: move)
    }
    
    return GameTree(board: board, eval: value, subtrees: next)
}

func allTrees(_ playerToMove: String, on board: [[String]]) -> [GameTree] {
    guard
        let possibleMoves = findPossibleMoves(playerToMove, on: board),
        !possibleMoves.isEmpty
    else {
        return [buildTree(playerToMove, on: board)]
    }
    
    var results = Array<GameTree?>(repeating: nil, count: possibleMoves.count)
    
    results.withUnsafeMutableBufferPointer { buffer in
        DispatchQueue.concurrentPerform(iterations: possibleMoves.count) { i in
            buffer[i] = buildTree(togglePlayer(playerToMove), on: possibleMoves[i])
        }
    }
    
    return results.map { $0! }
}

struct GameTree: Hashable {
    let board: [[String]]
    let eval: Int
    let subtrees: [GameTree]
    
    var endgames: Int {
        subtrees.isEmpty ? 1 : subtrees.map(\.endgames).reduce(0, +)
    }
    
    func countEvals() -> (neg1: Int, zero: Int, pos1: Int) {
        let selfCount: (Int, Int, Int)
        
        switch eval {
        case -1: selfCount = (1, 0, 0)
        case 0:  selfCount = (0, 1, 0)
        case 1:  selfCount = (0, 0, 1)
        default: selfCount = (0, 0, 0)
        }
        
        let subCounts = subtrees.map {
            $0.countEvals()
        }
        
        let totalNeg1 = subCounts.map(\.neg1).reduce(selfCount.0, +)
        let totalZero = subCounts.map(\.zero).reduce(selfCount.1, +)
        let totalPos1 = subCounts.map(\.pos1).reduce(selfCount.2, +)
        
        return (totalNeg1, totalZero, totalPos1)
    }
}

func nextPlayer(on board: [[String]]) -> String {
    let flat = board.flatMap { $0 }
    let x = flat.filter { $0 == "x" }.count
    let o = flat.filter { $0 == "o" }.count
    
    return x == o ? "x" : "o"
}

func minimaxScore(_ tree: GameTree, for player: String, depth: Int = 0) -> Int {
    if tree.subtrees.isEmpty {
        let base = player == "x" ? tree.eval : -tree.eval
        
        switch base {
        case 1:  return 10 - depth
        case -1: return -10 + depth
        default: return 0
        }
    }
    
    let maximizing = nextPlayer(on: tree.board) == player
    
    if maximizing {
        var best = Int.min
        
        for st in tree.subtrees {
            let s = minimaxScore(st, for: player, depth: depth + 1)
            
            if s > best {
                best = s
            }
        }
        
        return best
    } else {
        var best = Int.max
        
        for st in tree.subtrees {
            let s = minimaxScore(st, for: player, depth: depth + 1)
            
            if s < best {
                best = s
            }
        }
        
        return best
    }
}

func bestTrees(from roots: [GameTree], for player: String) -> [GameTree] {
    guard !roots.isEmpty else {
        return []
    }
    
    let scored = roots.map {
        (minimaxScore($0, for: player), $0)
    }
    
    let bestScore = scored.map {
        $0.0
    }.max()!
    
    return scored.filter {
        $0.0 == bestScore
    }.map {
        $0.1
    }
}

func bestMove(for player: String, on board: [[String]]) -> [[String]] {
    // First move always in center for optimization
    if player == "x" && board.flatMap({ $0 }).allSatisfy({ $0 == " " }) {
        var newBoard = board
        newBoard[1][1] = "x"
        return newBoard
    }
    
    let roots = allTrees(player, on: board)
    let best = bestTrees(from: roots, for: player)
    
    guard !best.isEmpty else {
        return board
    }
    
    let sorted = best.sorted { a, b in
        a.board.flatMap {
            $0
        }.joined() < b.board.flatMap {
            $0
        }.joined()
    }
    
    return sorted.first!.board
}

func randomMove(for player: String, on board: [[String]]) -> [[String]] {
    guard
        let moves = findPossibleMoves(player, on: board),
        !moves.isEmpty
    else {
        return board
    }
    
    return moves[
        Int.random(in: 0..<moves.count)
    ]
}

func play(_ games: Int, startingBoard: [[String]]? = nil) {
    var xWins = 0
    var oWins = 0
    var draws = 0
    
    for g in 1...games {
        let date1 = Date()
        
        var board = startingBoard ?? Array(repeating: Array(repeating: " ", count: 3), count: 3)
        var player = "x"
        
        while true {
            if playerHasWin("x", on: board) || playerHasWin("o", on: board) || isFull(board) {
                break
            }
            
            if player == "x" {
                board = bestMove(for: player, on: board)
            } else {
                board = randomMove(for: player, on: board)
            }
            
            player = togglePlayer(player)
        }
        
        let score = eval(board)
        
        if score == 1 {
            xWins += 1
        } else if score == -1 {
            oWins += 1
        } else {
            draws += 1
        }
        
        let date2 = Date()
        print("Time passed:", date2.timeIntervalSince(date1))
        
        print("game", g, "result:", score == 1 ? "x wins" : score == -1 ? "o wins" : "draw")
        printBoard(board)
        print("score so far -> x:", xWins, "o:", oWins, "draws:", draws)
    }
}

let startingBoard = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
//play(100, startingBoard: startingBoard)
