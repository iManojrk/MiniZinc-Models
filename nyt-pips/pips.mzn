include "alldifferent.mzn";

set of int: SUIT = 0..6;
array[int, 1..2] of SUIT: dominoes;

enum RegionType = {Empty, Equal, NotEqual, TotalEquals, TotalLessThan, TotalGreaterThan};
type Region = record(RegionType: r_type, 0..50: total);
array[int] of Region: regions;

array[int,int] of 0..length(regions): grid;

set of int: ROWS = index_set_1of2(grid);
set of int: COLS = index_set_2of2(grid);
int: ROW_COUNT = card(ROWS);
int: COL_COUNT = card(COLS);
set of int: REGIONS = index_set(regions);
set of int: DOMINOES = index_set_1of2(dominoes);

type Position = record(ROWS: r, COLS: c);

array[int] of array[int] of Position: region_cells = [
  [
    (r: r, c: c)
    | r in ROWS, c in COLS where grid[r,c] = ri
  ] | ri in REGIONS
];

array[SUIT] of 0..(card(DOMINOES)*2): domino_suit_count = array1d(SUIT, [
  sum(di in DOMINOES, s in 1..2) (
    bool2int(dominoes[di,s] = suit)
  )
  | suit in SUIT
]);

% calculating grid bounds all dominoes should be placed within the bounds
set of int: VALID_INDICES = { (r-1)*COL_COUNT + c | r in ROWS, c in COLS where grid[r,c] > 0 };

%%%%%%%%% Var %%%%%%%%%

array[DOMINOES, 1..2] of var Position: domino_positions;
array[ROWS, COLS] of var SUIT: pips;
array[DOMINOES, 1..2] of var VALID_INDICES: domino_index;

%%%%%%%%% Asserts %%%%%%%%%

% all regions should exist in the grid
constraint forall(ri in REGIONS) (
  assert(
    exists(r in ROWS, c in COLS) (
      grid[r,c] = ri
    ),
    "region " ++ show(ri) ++ " is not in the grid."
  )
);

function set of int: expand_neighbors(array[int] of Position: cells, set of int: visited) =
  visited union {
    j |
      i in visited,
      j in index_set(cells)
    where abs(cells[i].r - cells[j].r) + abs(cells[i].c - cells[j].c) = 1
  };

function set of int: flood(array[int] of Position: cells, set of int: visited, int: steps) =
  if steps = 0 \/ card(visited) = length(cells) then visited
  else flood(cells, expand_neighbors(cells, visited), steps - 1)
  endif;

% regions should be contiguous
constraint forall(ri in REGIONS) (
  let {
    array[int] of Position: cells = region_cells[ri],
    int: cell_count = length(cells),
    set of int: reachable = flood(
      cells,
      if cell_count = 0 then {}
      else {1}
      endif,
      cell_count
    )
  } in
  assert(
    cell_count = card(reachable),
    "region " ++ show(ri) ++ " is not contiguous."
  )
);

% total occupied cells equals twice the number of dominoes
constraint assert(
  sum(ri in REGIONS)(length(region_cells[ri])) = card(DOMINOES) * 2,
  "grid cells count must equal twice the domino count"
);



%%%%%%%%% Primary Constraints %%%%%%%%%

% the suits of a domino is next to each other
constraint forall(di in DOMINOES) (
  abs(domino_positions[di,1].r - domino_positions[di,2].r)
  + abs(domino_positions[di,1].c - domino_positions[di,2].c)
  = 1
);

% dominoes dont overlap each other
constraint forall(di in DOMINOES, s in 1..2) (
  domino_index[di,s] =
    (domino_positions[di,s].r - 1) * COL_COUNT + domino_positions[di,s].c
);
constraint alldifferent([domino_index[di,s] | di in DOMINOES, s in 1..2]);

% each domino end writes its suit into its cell
constraint forall(di in DOMINOES, s in 1..2) (
  let {
    var ROWS: r = domino_positions[di,s].r,
    var COLS: c = domino_positions[di,s].c
  } in
  pips[r,c] = dominoes[di,s]
);

% region rules
constraint forall(ri in REGIONS) (
  let {
    array[int] of Position: cells = region_cells[ri];
    Region: rg = regions[ri];
  } in
  if rg.r_type = Empty then
    true
  elseif rg.r_type = Equal then
    forall(cli in 2..length(cells)) (
      pips[cells[cli].r, cells[cli].c] = pips[cells[1].r, cells[1].c]
    )
  elseif rg.r_type = NotEqual then
    alldifferent([pips[cells[cli].r, cells[cli].c] | cli in index_set(cells)])
  elseif rg.r_type = TotalEquals then
    sum(cl1 in cells) (
      pips[cl1.r, cl1.c]
    ) = rg.total
  elseif rg.r_type = TotalGreaterThan then
    sum(cl1 in cells) (
      pips[cl1.r, cl1.c]
    ) > rg.total
  elseif rg.r_type = TotalLessThan then
    sum(cl1 in cells) (
      pips[cl1.r, cl1.c]
    ) < rg.total
  else false
  endif
);

%%%%%%%%% Secondary Constraints %%%%%%%%%

% explicit check: domino suits count matches pips on the grid
constraint forall(suit in SUIT) (
  domino_suit_count[suit] = sum(r in ROWS, c in COLS where grid[r,c] > 0) (
    bool2int(pips[r,c] = suit)
  )
);

% Fixing symmetric dominos for fewer turns
constraint forall(di in DOMINOES where dominoes[di, 1] = dominoes[di,2]) (
  domino_positions[di,1].r < domino_positions[di,2].r
  \/ domino_positions[di,1].c < domino_positions[di,2].c
);

%%%%%%%%% Output %%%%%%%%%

 output [
  "region cells\n",
  show(region_cells) ++ "\n",
  "dominoes\n",
  show(dominoes) ++ "\n",
  show(domino_positions),
  "\n\n"
];

output [
  show(dominoes[di, 1]) ++ " " ++ show(dominoes[di, 2]) ++ " | " ++
  show(if domino_positions[di,1].c < domino_positions[di,2].c then
    0
  elseif domino_positions[di,1].r < domino_positions[di,2].r then
    1
  elseif domino_positions[di,1].c > domino_positions[di,2].c then
    2
  elseif domino_positions[di,1].r > domino_positions[di,2].r then
    3
  else assert(false, "domino " ++ show(di) ++ " Cannot be displayed\n", di)
  endif)
  ++ " (" 
  ++ show(domino_positions[di,1].r) ++ ", " 
  ++ show(domino_positions[di,1].c)
  ++ ")\n"

  | di in DOMINOES
];

solve :: int_search([domino_index[di,s] | di in DOMINOES, s in 1..2], first_fail, indomain_min, complete) satisfy;
% solve :: int_search([pips[r,c] | r in ROWS, c in COLS], first_fail, indomain_min, complete) satisfy;
