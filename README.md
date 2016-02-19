# KK
A puzzle game for iOS based around the practice of simplifying boolean expressions.

The challenge: to make solving Karnaugh Maps a rewarding experience.

Based on the Quine-McCluskey simplification algorithm, implemented in Swift 2. (See QMCore.swift and QMClasses.swift)

I tried to make sure that the Q-M algorithm is error free, but I cannot guarantee it, since the debugging complexity increases with the number of variables. If a truth table has multiple solutions, the program will produce those solutions in an array of equations.
