%%%%%%%%% Partial Kropki constraints %%%%%%%%%

enum KRP_CellPairRelationship = {
  Krp_WhiteDot,
  Krp_BlackDot,
  Krp_X_Sum10,
  Krp_V_Sum5
};

% unified Kropki cell description from data
array[int] of record(Position: a, Position: b, KRP_CellPairRelationship: relation): krp_cells;

% partial Kropki constraints (dots that are present)
constraint forall(krp in krp_cells) (
  if krp.relation = Krp_WhiteDot then
    abs(cell(krp.a) - cell(krp.b)) = 1
  elseif krp.relation = Krp_BlackDot then
    (cell(krp.a) = 2 * cell(krp.b))
    \/
    (2 * cell(krp.a) = cell(krp.b))
  elseif krp.relation = Krp_V_Sum5 then
    (cell(krp.a) + cell(krp.b)) = 5
  elseif krp.relation = Krp_X_Sum10 then
    (cell(krp.a) + cell(krp.b)) = 10
  else
    assert(false, "Unexpected relationship type")
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
