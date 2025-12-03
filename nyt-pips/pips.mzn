include "alldifferent.mzn";

set of int: Suit = 0..6;
array[int, 1..2] of Suit: dominoes;

enum RegionType = {Empty, Equal, NotEqual, TotalEquals, TotalLessThan, TotalGreaterThan};
type Region = record(RegionType: r_type, 0..25: total);
array[int] of Region: regions;

array[int,int] of 0..length(regions): grid;

set of int: ROWS = index_set_1of2(grid);
set of int: COLS = index_set_2of2(grid);
set of int: REGIONS = index_set(regions);
set of int: DOMINOES = index_set_1of2(dominoes);

type Position = record(ROWS: r, COLS: c);

array[int] of array[int] of Position: region_cells = [
  [
    (r: r, c: c)
    | r in ROWS, c in COLS where grid[r,c] = ri
  ] | ri in REGIONS
];

%%%%%%%%% Var %%%%%%%%%

array[DOMINOES, 1..2] of var Position: domino_positions;
array[ROWS, COLS] of var Suit: pips;
int: COL_COUNT = card(COLS);
array[DOMINOES, 1..2] of var int: domino_end_index;

%%%%%%%%% Constraints %%%%%%%%%

% the suits of a domino is next to each other
constraint forall(di in DOMINOES) (
  abs(domino_positions[di,1].r - domino_positions[di,2].r)
  + abs(domino_positions[di,1].c - domino_positions[di,2].c)
  = 1
);

% all dominoes are placed within the bounds
constraint forall(di in DOMINOES, s in 1..2) (
  grid[domino_positions[di, s].r,domino_positions[di, s].c] > 0
);

% dominoes dont overlap each other
constraint forall(di in DOMINOES, s in 1..2) (
  domino_end_index[di,s] =
    (domino_positions[di,s].r - 1) * COL_COUNT + domino_positions[di,s].c
);
constraint alldifferent([domino_end_index[di,s] | di in DOMINOES, s in 1..2]);

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
