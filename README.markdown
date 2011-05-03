## About
Text-only implementation of Reversi (aka othelo) board game.

## Rules
Each piece must be placed in such a position that there exists at least one straight (horizontal, vertical, or diagonal) occupied line between the new piece and another same color piece, with one or more contiguous opposite pieces between them.

## Installation
You need the Glasgow Haskell compiler to install the game. The easiest way to get this done is installing the [Haskell platform](http://hackage.haskell.org/platform/).

In the console type

    runhaskell Setup.hs configure
    runhaskell Setup.hs build
    runhaskell Setup.hs install

Than you should run the programm simply running ``reversi``.
