%%%%%%%%% German Whispers constraints %%%%%%%%%

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

