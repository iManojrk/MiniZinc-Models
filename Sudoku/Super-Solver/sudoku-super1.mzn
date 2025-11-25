% Sudoku model in MiniZinc

include "alldifferent.mzn";

%%%%%%%% regular Sudoku constraints %%%%%%%%
int: size;

set of int: CLUE_DIGITS = 0..size;
set of int: DIGITS = 1..size;
set of int: INDEX_1D = 1..size;

% 0 for blanks
type Position= record(0..size: r, 0..size: c); 

array[INDEX_1D, INDEX_1D] of CLUE_DIGITS: clue;
array[INDEX_1D, INDEX_1D] of var DIGITS: grid;

% clue cells must match
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

%%%%%%%% Killer Sudoku constraints %%%%%%%%%

int: cage_count;
int: cage_max_length;

array[1..cage_count] of int: cage_totals;

array[1..cage_count, 1..cage_max_length] of Position: cage_cells;

constraint forall(cg in 1..cage_count) (
  sum([
    grid[cage_cells[cg, i].r, cage_cells[cg, i].c]
    | i in 1..cage_max_length 
    where cage_cells[cg, i].r != 0
  ]) = cage_totals[cg]
);

%%%%%%%% Thermometer constraints %%%%%%%%%

int: thermo_count;
int: thermo_max_length;

array[1..thermo_count, 1..thermo_max_length] of Position: thermo_cells;

constraint forall(th in 1..thermo_count) (
  forall(i in 2..thermo_max_length where thermo_cells[th, i].r != 0) (
    grid[thermo_cells[th, i-1].r, thermo_cells[th, i-1].c] < grid[thermo_cells[th, i].r, thermo_cells[th, i].c]
  )
);