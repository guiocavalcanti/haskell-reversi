import System.Cmd
import System.Environment
import Control.Monad(when)
import Text.JSON
import Data.Array

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

instance JSON State where
  showJSON X = showJSON "X"
  showJSON O = showJSON "O"
  showJSON E = showJSON "E"

  readJSON (JSString s)
    | str == "X" = Text.JSON.Ok $ X
    | str == "O" = Text.JSON.Ok $ O
    | otherwise = Text.JSON.Ok $ E
    where str = fromJSString s

boardR :: Result Board -> Board
boardR (Text.JSON.Ok b) = b

moveR :: Result Move -> Move
moveR (Text.JSON.Ok m) = m

main = do
  (cmd:args) <- getArgs

  if cmd == "play"
    then do
      let board = (boardR (decode (args!!0) :: Result Board) )
      let m = (moveR (decode (args!!1) :: Result Move))

      if check board m
        then do
          let new = flipChains (move board m) (fst m)
          if gameOver new
            then do
              let result = encode (toJSObject [("result", (winner new))])
              putStrLn result
            else do
              putStrLn (encode new)
        else
          putStrLn (encode board)
    else do
      putStrLn (encode makeBoard)
