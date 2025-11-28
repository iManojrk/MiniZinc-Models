%%%%%%%%% Killer Sudoku constraints %%%%%%%%%

int: cage_count;

array[1..cage_count] of opt int: cage_totals;

array[1..cage_count] of array[int] of Position: cage_cells;

% totals constraint
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

