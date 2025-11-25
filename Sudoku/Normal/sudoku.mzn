% Sudoku model in MiniZinc

include "alldifferent.mzn";

int: size;

set of int: CLUE_DIGITS = 0..size;
set of int: DIGITS = 1..size;

array[1..size, 1..size] of var CLUE_DIGITS: clue;
array[1..size, 1..size] of var DIGITS: grid;

% clue cells are fixed
constraint forall(r in 1..size, c in 1..size where clue[r,c] != 0) (
  grid[r,c] = clue[r,c]
);

% row constraints
constraint forall(r in 1..size) (
  alldifferent([grid[r,c] | c in 1..size])
);

% column constraints
constraint forall(c in 1..size) (
  alldifferent([grid[r,c] | r in 1..size])
);

% block constraints
int: block_size = round(sqrt(int2float(size)));
constraint forall(br in 0..block_size-1, bc in 0..block_size-1) (
  alldifferent([grid[br*block_size + r, bc*block_size + c] |
                 r in 1..block_size, c in 1..block_size])
);
