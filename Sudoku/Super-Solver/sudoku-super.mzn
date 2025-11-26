% Sudoku model in MiniZinc

include "alldifferent.mzn";

%%%%%%%% regular Sudoku constraints %%%%%%%%
int: size;

set of int: CLUE_DIGITS = 0..size;
set of int: DIGITS = 1..size;
set of int: INDEX_1D = 1..size;

% 0 for blanks
type Position = record(INDEX_1D: r, INDEX_1D: c);
% only r is checked for opt, c is
type Position_opt = record(opt INDEX_1D: r, opt INDEX_1D: c);


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

% totals constraint
int: cage_count;

array[1..cage_count] of opt int: cage_totals;

array[1..cage_count] of array[int] of Position: cage_cells;

constraint forall(cg in 1..cage_count where occurs(cage_totals[cg])) (
  let {
    array[int] of Position: cage = cage_cells[cg];
  } in
  sum([ grid[cage[i].r, cage[i].c] | i in index_set(cage) ]) ~= cage_totals[cg]
);

% no repeats within the cage
constraint forall(cage in cage_cells) (
  alldifferent([ grid[cage[i].r, cage[i].c] | i in index_set(cage) ])
);

%%%%%%%% Thermometer constraints %%%%%%%%%

array[int] of array[int] of Position: thermo_cells;

constraint forall(th in thermo_cells) (
  forall(i in 2..length(th)) (
    grid[th[i-1].r, th[i-1].c] 
    < grid[th[i].r, th[i].c]
  )
);

%%%%%%%% German Whispers constraints %%%%%%%%%

array[int] of array[int] of Position: GW_cells;
% this assumes adjacent cells in the array are the only neighbors (no cross linking)
constraint forall(ger in GW_cells) (
  forall(i in 2..length(ger)) (
    abs(
      grid[ger[i-1].r, ger[i-1].c] 
      - grid[ger[i].r, ger[i].c]
    ) >= 5
  )
);

%%%%%%%% Partial Kropki constraints %%%%%%%%%

array[int] of tuple(Position, Position): krp_cells_white;
array[int] of tuple(Position, Position): krp_cells_black;


constraint forall(krp in krp_cells_white) (
    abs(grid[krp.1.r, krp.1.c] - grid[krp.2.r, krp.2.c]) = 1
);

constraint forall(krp in krp_cells_black) (
  (grid[krp.1.r, krp.1.c] = 2 * grid[krp.2.r, krp.2.c])
  \/
  (2 * grid[krp.1.r, krp.1.c] = grid[krp.2.r, krp.2.c])
);

%%%%%%%% Partial Kropki assertion %%%%%%%%%

constraint assert(
  forall(krp in krp_cells_white) (
      ((krp.1.r = krp.2.r - 1) /\ (krp.1.c = krp.2.c))
      \/
      ((krp.1.r = krp.2.r) /\ (krp.1.c = krp.2.c - 1))
  ),
  "Input Error: Kropki white cell pairs must be adjacent to each other. Second position should be below or to the right of first index."
);

constraint assert(
  forall(krp in krp_cells_black) (
      ((krp.1.r = krp.2.r - 1) /\ (krp.1.c = krp.2.c))
      \/
      ((krp.1.r = krp.2.r) /\ (krp.1.c = krp.2.c - 1))
  ),
  "Input Error: Kropki black cell pairs must be adjacent to each other. Second position should be below or to the right of first index."
);

%%%%%%%% Full Kropki constraints %%%%%%%%%

bool: full_kropki;

% Getting horizontal pairs that are not white or black dots
array[INDEX_1D, 1..size-1] of bool: _krp_chk_horiz_no_dots
= array2d(INDEX_1D, 1..size-1, [
    not (((r: r, c: c), (r: r, c: c+1)) in (krp_cells_white ++ krp_cells_black))
    | r in INDEX_1D, c in 1..size-1
  ]
);

% Checking horizontal pairs that are not white or black dots
constraint (
  (not full_kropki) 
  \/ forall (r in INDEX_1D, c in 1..size-1 where _krp_chk_horiz_no_dots[r,c]) (
    (abs(grid[r, c] - grid[r, c+1]) != 1)
    /\
    (grid[r, c] != grid[r, c+1] * 2)
    /\
    (grid[r, c] * 2 != grid[r, c+1])
  )
);

% Getting vertical pairs that are not white or black dots
array[1..size-1, INDEX_1D] of bool: _krp_chk_vert_no_dots
= array2d(1..size-1, INDEX_1D, [
    not (((r: r, c: c), (r: r+1, c: c)) in (krp_cells_white ++ krp_cells_black))
    | r in 1..size-1, c in INDEX_1D
  ]
);

% Checking vertical pairs that are not white or black dots
constraint (
  (not full_kropki) 
  \/ forall (r in 1..size-1, c in INDEX_1D where _krp_chk_vert_no_dots[r,c]) (
    abs(grid[r, c] - grid[r+1, c]) != 1
    /\
    (grid[r, c] != grid[r+1, c] * 2)
    /\
    (grid[r, c] * 2 != grid[r+1, c])
  )
);
