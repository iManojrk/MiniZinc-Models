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
int: cage_max_length;

array[1..cage_count] of opt int: cage_totals;

array[1..cage_count, 1..cage_max_length] of Position_opt: cage_cells;

% array[1..cage_count] of DIGITS: cage_length = [
%   sum(cg in 1..cage_count) (bool2int(occurs(cage_cells[cg].r)))
% ]

constraint forall(cg in 1..cage_count where occurs(cage_totals[cg])) (
  sum([
    grid[cage_cells[cg, i].r, cage_cells[cg, i].c]
    | i in 1..cage_max_length 
    where occurs(cage_cells[cg, i].r)
  ]) = cage_totals[cg]
);

% no repeats within the cage
constraint forall(cg in 1..cage_count) (
  alldifferent([
    grid[cage_cells[cg, i].r, cage_cells[cg, i].c]
    | i in 1..cage_max_length 
    where occurs(cage_cells[cg, i].r)
  ])
);

%%%%%%%% Thermometer constraints %%%%%%%%%

int: thermo_count;
int: thermo_max_length;

array[1..thermo_count, 1..thermo_max_length] of Position_opt: thermo_cells;

constraint forall(th in 1..thermo_count) (
  forall(i in 2..thermo_max_length where occurs(thermo_cells[th, i].r)) (
    grid[thermo_cells[th, i-1].r, thermo_cells[th, i-1].c] 
    < grid[thermo_cells[th, i].r, thermo_cells[th, i].c]
  )
);

%%%%%%%% German Whispers constraints %%%%%%%%%

int: GW_count;
int: GW_max_length;

array[1..GW_count, 1..GW_max_length] of Position_opt: GW_cells;
% this assumes adjacent cells in the array are the only neighbors (no cross linking)
constraint forall(ger in 1..GW_count) (
  forall(i in 2..GW_max_length where occurs(GW_cells[ger, i].r)) (
    abs(
      grid[GW_cells[ger, i-1].r, GW_cells[ger, i-1].c] 
      - grid[GW_cells[ger, i].r, GW_cells[ger, i].c]
    ) >= 5
  )
);

%%%%%%%% Partial Kropki constraints %%%%%%%%%

int: krp_count_white;
array[1..krp_count_white] of tuple(Position, Position): krp_cells_white;

int: krp_count_black;
array[1..krp_count_black] of tuple(Position, Position): krp_cells_black;


constraint forall(krp in 1..krp_count_white) (
  let {
    Position: p1 = krp_cells_white[krp].1,
    Position: p2 = krp_cells_white[krp].2
  } in
    abs(grid[p1.r, p1.c] - grid[p2.r, p2.c]) = 1
);

constraint forall(krp in 1..krp_count_black) (
  let {
    Position: p1 = krp_cells_black[krp].1,
    Position: p2 = krp_cells_black[krp].2
  } in
    (grid[p1.r, p1.c] = 2 * grid[p2.r, p2.c])
    \/ (2 * grid[p1.r, p1.c] = grid[p2.r, p2.c])
);

%%%%%%%% Partial Kropki assertion %%%%%%%%%

constraint assert(
  forall(krp in 1..krp_count_white) (
      (
        (krp_cells_white[krp].1.r = krp_cells_white[krp].2.r - 1)
        /\
        (krp_cells_white[krp].1.c = krp_cells_white[krp].2.c)
      )
      \/
      (
        (krp_cells_white[krp].1.r = krp_cells_white[krp].2.r)
        /\
        (krp_cells_white[krp].1.c = krp_cells_white[krp].2.c - 1)
      )
  ),
  "Input Error: Kropki white cell pairs must be adjacent to each other. Second position should be below or to the right of first index."
);

constraint assert(
  forall(krp in 1..krp_count_black) (
      (
        (krp_cells_black[krp].1.r = krp_cells_black[krp].2.r - 1)
        /\
        (krp_cells_black[krp].1.c = krp_cells_black[krp].2.c)
      )
      \/
      (
        (krp_cells_black[krp].1.r = krp_cells_black[krp].2.r)
        /\
        (krp_cells_black[krp].1.c = krp_cells_black[krp].2.c - 1)
      )
  ),
  "Input Error: Kropki black cell pairs must be adjacent to each other. Second position should be below or to the right of first index."
);

%%%%%%%% Full Kropki constraints %%%%%%%%%

bool: full_kropki;

% checking horizontal pairs that are not white or black dots
array[INDEX_1D, 1..size-1] of bool: _krp_chk_horiz_no_dots
= array2d(INDEX_1D, 1..size-1, [
    not (((r: r, c: c), (r: r, c: c+1)) in (krp_cells_white ++ krp_cells_black))
    | r in INDEX_1D, c in 1..size-1
  ]
);

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

% checking vertical pairs that are not white or black dots
array[1..size-1, INDEX_1D] of bool: _krp_chk_vert_no_dots
= array2d(1..size-1, INDEX_1D, [
    not (((r: r, c: c), (r: r+1, c: c)) in (krp_cells_white ++ krp_cells_black))
    | r in 1..size-1, c in INDEX_1D
  ]
);

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
