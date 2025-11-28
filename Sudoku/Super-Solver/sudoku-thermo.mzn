%%%%%%%%% Thermometer constraints %%%%%%%%%

array[int] of array[int] of Position: thermo_cells;

constraint forall(th in thermo_cells) (
  forall(i in 2..length(th)) (
    grid[th[i-1].r, th[i-1].c] 
    < grid[th[i].r, th[i].c]
  )
);

