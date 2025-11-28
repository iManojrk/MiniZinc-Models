%%%%%%%%% Knight constraints %%%%%%%%%

% relative row/column offsets for a knight move
type KnightMove = record(int: r, int: c);

array[int] of KnightMove: knight_moves = [
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
constraint forall(r, c in INDEX_1D) (
  forall(mv in knight_moves where (r+mv.r) in INDEX_1D /\ (c+mv.c) in INDEX_1D) (
    grid[r, c] != grid[r+mv.r, c+mv.c]
  )
);

