% Sudoku model in MiniZinc

include "alldifferent.mzn";

% regular Sudoku constraints
int: size;

set of int: CLUE_DIGITS = 0..size;
set of int: DIGITS = 1..size;
set of int: INDEX_1D = 1..size;

array[INDEX_1D, INDEX_1D] of var CLUE_DIGITS: clue;
array[INDEX_1D, INDEX_1D] of var DIGITS: grid;

% clue cells are fixed
constraint forall(r in INDEX_1D, c in INDEX_1D where clue[r,c] != 0) (
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
constraint forall(br in 0..block_size-1, bc in 0..block_size-1) (
  alldifferent([grid[br*block_size + r, bc*block_size + c] |
                 r in 1..block_size, c in 1..block_size])
);

% Killer Sudoku constraints

int: num_cages;
int: max_cage_cells;

% 0 for blanks
type Position = record(0..size: r, 0..size: c); 

array[1..num_cages] of int: cage_totals;

array[1..num_cages, 1..max_cage_cells] of Position: cages;

constraint forall(cg in 1..num_cages) (
  sum([
    grid[cages[cg, i].r, cages[cg, i].c]
    | i in 1..max_cage_cells 
    where cages[cg, i].r != 0
  ]) = cage_totals[cg]
)