include "../../sudoku-core.mzn";
include "../../sudoku-thermo.mzn";
include "../../sudoku-knight.mzn";

% Solution

%%%%%%%%%% Sudoku parameters %%%%%%%%%%
size = 9;

clue = [|
    0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  
  | 0, 0, 6,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   2, 0, 0,   0, 0, 0
  |];

%%%%%%%%%% Thermometer parameters %%%%%%%%%%

thermo_cells = [
  [(r: 7, c: 4), (r: 6, c: 4), (r: 5, c: 3), (r: 4, c: 2), (r: 3, c: 3), (r: 2, c: 4)],
  [(r: 7, c: 6), (r: 6, c: 6), (r: 5, c: 7), (r: 4, c: 8), (r: 3, c: 7), (r: 2, c: 6)],
];
