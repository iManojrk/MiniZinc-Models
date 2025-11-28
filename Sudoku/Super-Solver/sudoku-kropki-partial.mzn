%%%%%%%%% Partial Kropki constraints %%%%%%%%%

enum CellPairRelationship = {
  WhiteDot,
  BlackDot,
  X_Sum10,
  V_Sum5
};

% unified Kropki cell description from data
array[int] of record(Position: a, Position: b, CellPairRelationship: relation): krp_cells;

% partial Kropki constraints (dots that are present)
constraint forall(krp in krp_cells) (
  if krp.relation = WhiteDot then
    abs(grid[krp.a.r, krp.a.c] - grid[krp.b.r, krp.b.c]) = 1
  elseif krp.relation = BlackDot then
    (grid[krp.a.r, krp.a.c] = 2 * grid[krp.b.r, krp.b.c])
    \/
    (2 * grid[krp.a.r, krp.a.c] = grid[krp.b.r, krp.b.c])
  else
    true
  endif
);

% adjacency assertion for all Kropki pairs
constraint assert(
  forall(krp in krp_cells) (
      ((krp.a.r = krp.b.r - 1) /\ (krp.a.c = krp.b.c))
      \/
      ((krp.a.r = krp.b.r) /\ (krp.a.c = krp.b.c - 1))
  ),
  "Input Error: Kropki cell pairs must be adjacent to each other. Second position should be below or to the right of first index."
);
