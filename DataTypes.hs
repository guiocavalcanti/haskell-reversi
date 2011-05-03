module DataTypes where

import Data.Array

-- Possible states of a given point in a board
data State = X | O | E
  deriving (Eq, Show, Read)

type Board = Array (Int,Int) State
type Position = (Int,Int)
type Move = (Position, State)
