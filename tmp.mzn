% Simple MiniZinc model demonstrating nested if-then-else (since `case` is not
% supported in this MiniZinc version).

int: x = 2;

string: description =
  if x = 1 then "one"
  elseif x = 2 then "two"
  elseif x = 3 then "three"
  else "other"
  endif;

solve satisfy;

output [
  "x = " ++ show(x) ++ "\n" ++
  "description = " ++ description ++ "\n"
];
