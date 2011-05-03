import System.Cmd
import Control.Monad(when)

import DataTypes
import Board

gameOver :: Board -> Bool
gameOver b = not (hasMovesFor b X || hasMovesFor b O)

count :: Board -> State -> Int
count b s = sum [ 1 | (i,j) <- indexes b , value b (i,j) == s ]

winner :: Board -> State
winner b
  | gameOver b && ( count b X > count b O ) = X
  | gameOver b && ( count b O > count b X ) = O

loop :: Board -> IO ()
loop board = do
  system "clear"
  showBoard board
  if gameOver board
    then do
      putStrLn ( "Game over! Winner: " ++ show (winner board) )
      return ()
    else do
      command <- getLine
      when (not $ null command) $ do
        let m = read command :: Move
        -- debug
        -- putStrLn (show (allChains (move board m) (fst m)))
        -- putStrLn (show (map hasChain (allChains (move board m) (fst m))))
        if check board m
          then do
            let new = flipChains (move board m) (fst m)
            loop new
          else
            loop board

main = do
  let board = makeBoard
  loop board
