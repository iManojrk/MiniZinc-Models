%%%%%%%%% Arrow constraints %%%%%%%%%

type Arrow = record(Position: circle, array[int] of Position: stem);

array[int] of Arrow: arrows;

constraint forall(arrow in arrows) (
  cell(arrow.circle) = sum(st in arrow.stem) (cell(st))
);