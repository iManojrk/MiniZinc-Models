include "../../sudoku-core.mzn";
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

%%%%%%%% Arrow parameters %%%%%%%%%

arrows = [
  (circle: (r: 1, c: 2), stem: [(r: 2, c: 3), (r: 3, c: 2)]),
  (circle: (r: 1, c: 3), stem: [(r: 2, c: 2), (r: 3, c: 3)]),
  (circle: (r: 1, c: 6), stem: [(r: 2, c: 7), (r: 3, c: 6), (r: 4, c: 7), (r: 5, c: 6)]),
  (circle: (r: 1, c: 7), stem: [(r: 2, c: 6), (r: 3, c: 7), (r: 4, c: 6)]),
  (circle: (r: 4, c: 4), stem: [(r: 4, c: 5), (r: 5, c: 4)]),
  (circle: (r: 6, c: 6), stem: [(r: 6, c: 5), (r: 5, c: 6)]),
  (circle: (r: 9, c: 3), stem: [(r: 8, c: 4), (r: 7, c: 3), (r: 6, c: 4)]),
  (circle: (r: 9, c: 4), stem: [(r: 8, c: 3), (r: 7, c: 4), (r: 6, c: 3), (r: 5, c: 4)]),
  (circle: (r: 9, c: 7), stem: [(r: 8, c: 7), (r: 7, c: 7)]),
  (circle: (r: 9, c: 8), stem: [(r: 8, c: 7), (r: 7, c: 8)])
];