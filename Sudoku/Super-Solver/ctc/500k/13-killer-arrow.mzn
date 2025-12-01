include "../../sudoku-core.mzn";
include "../../sudoku-killer.mzn";
include "../../sudoku-arrows.mzn";

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

%%%%%%%%%% Killer parameters %%%%%%%%%%

cage_count = 9;

cage_totals = [9, 8, 6, 12, 22, 14, 9, 7, 9];

cage_cells = [
  [(r: 1, c: 2), (r: 2, c: 2)],
  [(r: 1, c: 4), (r: 1, c: 5), (r: 1, c: 6)],
  [(r: 1, c: 8), (r: 2, c: 8)],
  [(r: 3, c: 1), (r: 4, c: 1)],
  [(r: 4, c: 5), (r: 5, c: 5), (r: 6, c: 5)],
  [(r: 6, c: 9), (r: 7, c: 9)],
  [(r: 8, c: 2), (r: 9, c: 2)],
  [(r: 8, c: 8), (r: 9, c: 8)],
  [(r: 9, c: 4), (r: 9, c: 5), (r: 9, c: 6)],
];
  
%%%%%%%% Arrow parameters %%%%%%%%%

arrows = [
  (circle: (r: 4, c: 2), stem: [(r: 3, c: 3), (r: 3, c: 4), (r: 3, c: 5)]),
  (circle: (r: 4, c: 8), stem: [(r: 3, c: 7), (r: 3, c: 6)]),
  (circle: (r: 6, c: 2), stem: [(r: 7, c: 3), (r: 7, c: 4)]),
  (circle: (r: 6, c: 8), stem: [(r: 7, c: 7), (r: 7, c: 6), (r: 7, c: 5)])
];