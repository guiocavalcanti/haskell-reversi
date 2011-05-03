import Test.HUnit

import DataTypes
import Board


game1 = [((6,5),O),((6,4),X),((6,3),O),((7,4),X),((7,3),O),((7,6),X), ((7,5),O),((8,4),X),((8,7),O),((8,6),X),((8,5),O),((3,3),O),((3,5),X),((4,3),O),((3,2),X),((3,6),O),((4,6),X),((2,1),O),((5,2),X),((3,7),O),((3,8),X),((2,7),O),((8,8),X)]
game2 = moves makeBoard [((1,1),X),((1,2),X),((1,3),X),((1,4),X),((1,5),X),((1,6),X),((1,7),X),((1,8),X),
         ((2,1),X),((2,2),X),((2,3),X),((2,4),X),((2,5),X),((2,6),X),((2,7),X),((2,8),X),
         ((3,1),X),((3,2),X),((3,3),X),((3,4),X),((3,5),X),((2,6),X),((3,7),X),((3,8),X),
         ((4,1),X),((4,2),X),((4,3),X),((4,4),X),((4,5),X),((4,6),X),((4,7),X),((4,8),E),
         ((5,1),X),((5,2),X),((5,3),X),((5,4),X),((5,5),X),((5,6),X),((5,7),E),((5,8),E),
         ((6,1),X),((6,2),X),((6,3),X),((6,4),X),((6,5),X),((6,6),X),((6,7),E),((6,8),O),
         ((7,1),X),((7,2),X),((7,3),X),((7,4),X),((7,5),X),((7,6),X),((7,7),X),((7,8),E),
         ((8,1),X),((8,2),X),((8,3),X),((8,4),X),((8,5),X),((8,6),X),((8,7),X),((8,8),X)]

checkTest = TestList [ TestCase (assertEqual "North O,X,O"
                        True (check makeBoard ((6,5),O))),
                      TestCase (assertEqual "East O,X,O"
                        True (check makeBoard ((4,3),O))),
                      TestCase (assertEqual "Top left L"
                        False (let board = moves makeBoard [((6,4),X), ((4,4),O), ((5,4),X), ((4,3),O)]
                                  in check board ((6,5),X))),
                      TestCase (assertEqual "North X,X,O"
                        False (let board = moves makeBoard [((6,4),X), ((4,4),O), ((5,4),X), ((4,3),O)]
                                  in check board ((7,4),X)))]


hasMovesForTest = TestList [ TestCase (assertEqual "game 2"
                              False (hasMovesFor game2 X)),
                            TestCase (assertEqual "game 2"
                              False (hasMovesFor game2 O))]

hasChainTest = TestList [ TestCase (assertEqual "O,X,X,O,E"
                    (hasChain [((1,1),O),((1,1),X),((1,1),X),((1,1),O),((1,1),E)] ) True),
                TestCase (assertEqual "X"
                    (hasChain [((1,1),X)]) False),
                TestCase (assertEqual "O,O"
                    (hasChain [((1,1),O),((1,1),O)]) False),
                TestCase (assertEqual "X,O,E,X"
                    (hasChain [((1,1),X),((1,1),O),((1,1),E),((1,1),X)]) False ),
                TestCase (assertEqual "X,E,E,X"
                    (hasChain [((1,1),X),((1,1),E),((1,1),E),((1,1),X)]) False ),
                TestCase (assertEqual "X,E,O,O"
                    (hasChain [((1,1),X),((1,1),E),((1,1),O),((1,1),O)]) False ),
                TestCase (assertEqual "X,O,O,O"
                    (hasChain [((1,1),X),((1,1),O),((1,1),O),((1,1),O)]) False ),
                TestCase (assertEqual "X,X,O,E"
                    (hasChain [((1,1),X),((1,1),X),((1,1),O),((1,1),E)]) False ),
                TestCase (assertEqual "X,X,O,E"
                    (hasChain [((1,1),X),((1,1),X),((1,1),O),((1,1),E)]) False ),
                TestCase (assertEqual "X,E"
                    (hasChain [((1,1),X),((1,1),E)]) False )]

sliceTest = TestList [ TestCase (assertEqual "Top right corner"
                          [((1,8),E)] (slice makeBoard (1,8) (-1,1))),
                        TestCase (assertEqual "Bottom right corner"
                          [((8,8),E)] (slice makeBoard (8,8) (1,1))) ]


tests = TestList [ sliceTest, hasChainTest, checkTest, hasMovesForTest ]
