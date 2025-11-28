include "./sudoku-kropki-partial.mzn";

%%%%%%%%% Full Kropki constraints %%%%%%%%%

% cell pairs that actually have a dot (white or black), used for full Kropki
array[int] of tuple(Position, Position): krp_cell_pairs =
  [ (krp.a, krp.b)
    | krp in krp_cells
    where krp.relation = Krp_WhiteDot \/ krp.relation = Krp_BlackDot
  ];

% Getting horizontal pairs that are not white or black dots
array[INDEX_1D, 1..size-1] of bool: _krp_chk_horiz_no_dots
= array2d(INDEX_1D, 1..size-1, [
    not (((r: r, c: c), (r: r, c: c+1)) in krp_cell_pairs)
    | r in INDEX_1D, c in 1..size-1
  ]
);

% Checking horizontal pairs that are not white or black dots
constraint forall (r in INDEX_1D, c in 1..size-1 where _krp_chk_horiz_no_dots[r,c]) (
  (abs(grid[r, c] - grid[r, c+1]) != 1)
  /\
  (grid[r, c] != grid[r, c+1] * 2)
  /\
  (grid[r, c] * 2 != grid[r, c+1])
);

% Getting vertical pairs that are not white or black dots
array[1..size-1, INDEX_1D] of bool: _krp_chk_vert_no_dots
= array2d(1..size-1, INDEX_1D, [
    not (((r: r, c: c), (r: r+1, c: c)) in krp_cell_pairs)
    | r in 1..size-1, c in INDEX_1D
  ]
);

% Checking vertical pairs that are not white or black dots
constraint forall (r in 1..size-1, c in INDEX_1D where _krp_chk_vert_no_dots[r,c]) (
  abs(grid[r, c] - grid[r+1, c]) != 1
  /\
  (grid[r, c] != grid[r+1, c] * 2)
  /\
  (grid[r, c] * 2 != grid[r+1, c])
);
