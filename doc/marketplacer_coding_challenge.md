---
source:
- title: marketplacer_coding_challenge.md
  url: https://gist.github.com/mipearson/572ee773572b9b7f9372c6f98feb3bfc
---

The goal of this challenge is to implement Conway's Game of Life in Ruby or
Javascript (browser or node.js).

From https://en.wikipedia.org/wiki/Conway's_Game_of_Life :

> The Game of Life, also known simply as Life, is a cellular automaton devised
> by the British mathematician John Horton Conway in 1970.
>
> The "game" is a zero-player game, meaning that its evolution is determined by
> its initial state, requiring no further input. One interacts with the Game of
> Life by creating an initial configuration and observing how it evolves, or,
> for advanced "players", by creating patterns with particular properties.

You're going to write a program that initializes a fixed-size board with a
random state and then shows a number of "iterations" of the board following the
rules of the Game of Life.

1. Assume a fixed size board, eg 80 columns by 20 rows
1. To start the game, randomly set each cell on the board either ON or OFF
1. Print the status of the board to the screen
1. Enter an infinite loop:
  1. Wait half a second
  1. Produce a new "tick" of the board
  1. Print the status of the board to the screen

The wikipedia article linked above describes the rules for each "tick":

> Every cell interacts with its eight neighbours, which are the cells that are
> horizontally, vertically, or diagonally adjacent. At each step in time, the
> following transitions occur:

> Any live cell with fewer than two live neighbours dies, as if caused by
> underpopulation.
> Any live cell with two or three live neighbours lives on to the next
> generation.
> Any live cell with more than three live neighbours dies, as if by
> overpopulation.
> Any dead cell with exactly three live neighbours becomes a live cell, as if by
> reproduction.

> The initial pattern constitutes the seed of the system. The first generation
> is created by applying the above rules simultaneously to every cell in the
> seed—births and deaths occur simultaneously, and the discrete moment at which
> this happens is sometimes called a tick (in other words, each generation is a
> pure function of the preceding one). The rules continue to be applied
> repeatedly to create further generations.

Optionally, you can also have your program read in the initial board state from
standard input (if in Ruby) or a textarea (if in browser javascript) and do
clever things with printing the board.

We'll pair with you on successsful submissions to add features or refactor the
code. Include in your submission comments as to possible improvements or areas
where you feel that it could be done better.

Tips:

  * Don't try to modify the board in-place on each tick: instead, produce a new
    board that replaces the old
  * If you google "conway's game of life", you'll see a live javascript example
    in your browser. The rules make much more sense when you can see them play
    out.
  * Your submission can be one small script or many files, it's up to you
  * Unit / functional / integration tests are allowed but not required
  * Your submission must be your own work with no direct assistance from
    colleagues or mentors

If these instructions are confusing, we're happy to answer questions about them.
