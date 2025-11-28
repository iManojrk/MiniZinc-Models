include "alldifferent.mzn";
include "inverse.mzn";

%%%%%%%%% regular Sudoku constraints %%%%%%%%%

int: size;

set of int: CLUE_DIGITS = 0..size;
set of int: DIGITS      = 1..size;
set of int: INDEX_1D    = 1..size;

type Position = record(INDEX_1D: r, INDEX_1D: c);

array[INDEX_1D, INDEX_1D] of CLUE_DIGITS: clue;
array[INDEX_1D, INDEX_1D] of var DIGITS:   grid;

% clue cells must match
constraint forall(r, c in INDEX_1D where clue[r,c] != 0) (
  grid[r,c] = clue[r,c]
);

% row constraints
constraint forall(r in INDEX_1D) (
  alldifferent([grid[r,c] | c in INDEX_1D])
);

% column constraints
constraint forall(c in INDEX_1D) (
  alldifferent([grid[r,c] | r in INDEX_1D])
);

% block constraints
int: block_size = round(sqrt(int2float(size)));
constraint forall(br, bc in 0..block_size-1) (
  alldifferent([grid[br*block_size + r, bc*block_size + c] |
                 r in 1..block_size, c in 1..block_size])
);

