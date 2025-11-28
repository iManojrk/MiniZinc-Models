%%%%%%%%% Thermometer constraints %%%%%%%%%

array[int] of array[int] of Position: thermo_cells;

constraint forall(th in thermo_cells) (
  forall(i in 2..length(th)) (
    cell(th[i-1]) < cell(th[i])
  )
);
