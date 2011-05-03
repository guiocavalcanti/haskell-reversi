module Board
(showBoard
,makeBoard
,move
,check
,flipChains
,hasMovesFor
,hasChain
,slice
,moves
,indexes
,value) where

import Data.Array

import DataTypes

showBoard :: Board -> IO ()
showBoard b = putStrLn $ tablerize (prettify b)
  where prettify b = foldr1 (\x acc -> x ++ "\n" ++ acc) board
          where line r = foldr (\x acc -> " " ++ (show x) ++ " " ++ acc) "" ( map ((!) b) r )
                board = [ line ( range ((i,1),(i,8)) ) | i <- [1..8]]
        tablerize b = column 1 $ " " ++ row ++ "\n" ++ b
          where row = foldr (\x acc -> " " ++ (show x) ++ " " ++ acc) "" [1..8]
                column i [] = []
                column i (x:xs)
                  | x == '\n' = (x : (show i)) ++ (column (i+1) xs)
                  | otherwise = (x : column i xs)

-- Make a 8-board with 4 centered pieces (othello rules)
makeBoard :: Board
makeBoard = board n // [((4,4), X), ((4,5), O), ((5,4), O), ((5,5), X)]
  where board n = array ((1,1), n) [ ((i,j), E) | (i,j) <- range ((1,1), n)]
        n = (8,8)

-- Adds or updates a given piece
move :: Board -> Move -> Board
move b (p, s) = b // [(p,s)]

moves :: Board -> [Move] -> Board
moves b mvs = b // mvs

-- Checks if some move is valid
check :: Board -> Move -> Bool
check b m = empty b p && (foldr (||) False (map hasChain (allChains newBoard p)))
  where newBoard = move b m
        p = fst m

-- Turns out all flankered pieces
flipChains :: Board -> Position -> Board
flipChains b p = foldr (\x bacc -> if hasChain x then moves bacc $ turnChain x else bacc) b chains
  where chains = allChains b p
        turnChain ps = map turnPiece $ takeWhile (\x -> current /= snd x ) (tail ps)
        turnPiece (p,s)
          | s == O = (p,X)
          | otherwise = (p,O)
        current = b!p

-- Finds the all 8 possible chains for a given position
allChains :: Board -> Position -> [[(Position, State)]]
allChains b p = map (slice b p) [(-1,0),(-1,1),(0,1),(1,1),(1,0),(1,-1),(0,-1),(-1,-1)]

-- Check if there are a chain of pieces other than the first one
hasChain :: [(Position, State)] -> Bool
hasChain ((m,s):ms) = hasChainOf s ms 0
  where hasChainOf _ [] _ = False
        hasChainOf sym (x:xs) pos
          | snd x == sym = pos /= 0
          | snd x /= E = hasChainOf sym xs (pos+1)
          | otherwise = False

slice :: Board -> Position -> (Int,Int) -> [(Position, State)]
slice b (i,j) (di,dj)
  | inRange (bounds b) (i,j) = (current : slice b (i+di,j+dj) (di,dj))
  | otherwise = []
    where current  = ((i,j), b!(i,j))

-- Checks if there is at least one valid move for the given state
hasMovesFor :: Board -> State -> Bool
hasMovesFor b s = foldr1 (||) moves
  where moves = [ check b ((i,j),s) | (i,j) <- range (bounds b) ]

-- Verifies if a given position is empty
empty :: Board -> Position -> Bool
empty b p = (b!p) == E

-- All possible indexes for the board
indexes :: Board -> [(Int,Int)]
indexes b = range (bounds b)

-- Current state of given position
value :: Board -> Position -> State
value b p = b!p
