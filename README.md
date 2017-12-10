# Logik
Pascal project for programming course on University - bot for playing Mastermind

Code comments are in czech only.

Joel Jancarik 2012/2013 course project for Programovani I NMIN101.

In the game there are n colours and k places (so it tries to be as general as possible).
The places are filled with colours and we are trying to guess which colours are in which places.
In each turn we need guess some colour for each (k) places.
If we guess colour, which is in some other place, we get one white point.
If we guess colour on right place we get black point.

The bot works in two phases. In the first phase he tries to reduce possible splace. In the second phase the bot uses brute force.
