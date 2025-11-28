%%%%%%%%% Knight constraints %%%%%%%%%

% enable/disable chess-knight non-equal constraint
bool: knight;

% relative row/column offsets for a knight move
type Move = record(int: r, int: c);

array[int] of Move: moves = [
  (r: -2, c: -1),
  (r: -1, c: -2),
  (r: -2, c: 1),
  (r: -1, c: 2),
  (r: 2, c: -1),
  (r: 1, c: -2),
  (r: 2, c: 1),
  (r: 1, c: 2),
];

% when enabled, no two cells a knight's move apart may contain the same digit
constraint knight ->
  forall(r, c in INDEX_1D) (
    forall(mv in moves where (r+mv.r) in INDEX_1D /\ (c+mv.c) in INDEX_1D) (
      grid[r, c] != grid[r+mv.r, c+mv.c]
    )
  );

