include "../../sudoku-core.mzn";
include "../../sudoku-kropki.mzn";

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
  (a: (r: 1, c: 1), b: (r: 1, c: 2), relation: WhiteDot),
  (a: (r: 2, c: 1), b: (r: 3, c: 1), relation: WhiteDot),
  (a: (r: 2, c: 4), b: (r: 2, c: 5), relation: WhiteDot),
  (a: (r: 3, c: 4), b: (r: 4, c: 4), relation: WhiteDot),
  (a: (r: 4, c: 2), b: (r: 4, c: 3), relation: WhiteDot),
  (a: (r: 4, c: 8), b: (r: 4, c: 9), relation: WhiteDot),
  (a: (r: 5, c: 2), b: (r: 6, c: 2), relation: WhiteDot),
  (a: (r: 5, c: 7), b: (r: 6, c: 7), relation: WhiteDot),
  (a: (r: 5, c: 8), b: (r: 5, c: 9), relation: WhiteDot),
  (a: (r: 6, c: 3), b: (r: 6, c: 4), relation: WhiteDot),
  (a: (r: 7, c: 1), b: (r: 8, c: 1), relation: WhiteDot),
  (a: (r: 7, c: 2), b: (r: 8, c: 2), relation: WhiteDot),
  (a: (r: 7, c: 5), b: (r: 8, c: 5), relation: WhiteDot),
  (a: (r: 7, c: 6), b: (r: 7, c: 7), relation: WhiteDot),
  (a: (r: 8, c: 6), b: (r: 8, c: 7), relation: WhiteDot),
  (a: (r: 8, c: 7), b: (r: 9, c: 7), relation: WhiteDot),
  (a: (r: 9, c: 8), b: (r: 9, c: 9), relation: WhiteDot),
  (a: (r: 1, c: 6), b: (r: 1, c: 7), relation: BlackDot),
  (a: (r: 3, c: 1), b: (r: 4, c: 1), relation: BlackDot),
  (a: (r: 3, c: 2), b: (r: 4, c: 2), relation: BlackDot),
  (a: (r: 3, c: 6), b: (r: 4, c: 6), relation: BlackDot),
  (a: (r: 4, c: 1), b: (r: 4, c: 2), relation: BlackDot),
  (a: (r: 5, c: 3), b: (r: 6, c: 3), relation: BlackDot),
  (a: (r: 5, c: 7), b: (r: 5, c: 8), relation: BlackDot),
  (a: (r: 6, c: 4), b: (r: 6, c: 5), relation: BlackDot),
  (a: (r: 8, c: 8), b: (r: 8, c: 9), relation: BlackDot)
];

%%%%%%%% Full Kropki parameters %%%%%%%%%

full_kropki = true;
