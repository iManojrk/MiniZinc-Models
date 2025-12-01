include "../../sudoku-core.mzn";
include "../../sudoku-kropki-partial.mzn";
include "../../sudoku-sandwich.mzn";

% Solution

%%%%%%%%%% Sudoku parameters %%%%%%%%%%
size = 9;

clue = [|
    0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  |];

%%%%%%%% Partial Kropki parameters %%%%%%%%%

krp_cells = [
  (a: (r: 2,c: 2), b: (r: 2,c: 3), relation: Krp_V_Sum5),
  (a: (r: 2,c: 7), b: (r: 2,c: 8), relation: Krp_V_Sum5),
  (a: (r: 3,c: 6), b: (r: 4,c: 6), relation: Krp_V_Sum5),
  (a: (r: 5,c: 2), b: (r: 5,c: 3), relation: Krp_X_Sum10),
  (a: (r: 5,c: 7), b: (r: 5,c: 8), relation: Krp_X_Sum10),
  (a: (r: 6,c: 4), b: (r: 7,c: 4), relation: Krp_X_Sum10),
  (a: (r: 7,c: 5), b: (r: 8,c: 5), relation: Krp_V_Sum5),
  (a: (r: 8,c: 1), b: (r: 8,c: 2), relation: Krp_X_Sum10),
  (a: (r: 8,c: 8), b: (r: 8,c: 9), relation: Krp_X_Sum10),
];

%%%%%%%% Sandwich parameters %%%%%%%%%

swh_row_sums = [30, 5, 4, <>, 10, <>, 30, 15, 4];
swh_col_sums = [<>, 3, <>, <>, 6, <>, 25, 9, <>];
