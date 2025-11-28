include "inverse.mzn";

%%%%%%%%% Sandwich constraints %%%%%%%%%

% enable/disable sandwich sums (digits between 1 and 9)
bool: sandwich;

% optional sums between 1 and 9 for each row/column (<> means "no sandwich clue")
array[INDEX_1D] of opt 0..35: swh_row_sums;
array[INDEX_1D] of opt 0..35: swh_col_sums;

array[INDEX_1D, DIGITS] of var INDEX_1D: row_pos;
constraint sandwich ->
  forall(r in INDEX_1D where occurs(swh_row_sums[r])) (
    inverse(
      [grid[r, c] | c in INDEX_1D],
      [row_pos[r, d] | d in DIGITS]
    )
  );

% if a row sandwich sum is given, constraint the sum of digits strictly between 1 and 9
constraint sandwich ->
  forall(r in INDEX_1D where occurs(swh_row_sums[r])) (
    let {
      var INDEX_1D: min_i = min(row_pos[r,1], row_pos[r,9]);
      var INDEX_1D: max_i = max(row_pos[r,1], row_pos[r,9]);
    } in
    sum([ grid[r, c] | c in min_i+1..max_i-1 ]) = swh_row_sums[r]
  );

array[DIGITS, INDEX_1D] of var INDEX_1D: col_pos;
constraint sandwich ->
  forall(c in INDEX_1D where occurs(swh_col_sums[c])) (
    inverse(
      [grid[r, c] | r in INDEX_1D],
      [col_pos[d, c] | d in DIGITS]
    )
  );

% if a column sandwich sum is given, constraint the sum of digits strictly between 1 and 9
constraint sandwich ->
  forall(c in INDEX_1D where occurs(swh_col_sums[c])) (
    let {
      var INDEX_1D: min_i = min(col_pos[1,c], col_pos[9,c]);
      var INDEX_1D: max_i = max(col_pos[1,c], col_pos[9,c]);
    } in
    sum([ grid[r, c] | r in min_i+1..max_i-1 ]) = swh_col_sums[c]
  );

array[0..35] of int: swh_min_len = array1d(0..35, [
  % 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
    0, 9, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 9, 7
]);

array[0..35] of int: swh_max_len = array1d(0..35, [
  % 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
    0, 9, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 9, 7
]);

constraint sandwich ->
  forall(r in INDEX_1D where occurs(swh_row_sums[r])) (
    let {
      var 0..7: distance = abs(row_pos[r, 1] - row_pos[r, 9]) - 1
    } in
    distance >= swh_min_len[swh_row_sums[r]]
    /\
    distance <= swh_max_len[swh_row_sums[r]]
  );

constraint sandwich ->
  forall(c in INDEX_1D where occurs(swh_col_sums[c])) (
    let {
      var 0..7: distance = abs(col_pos[1, c] - col_pos[9, c]) - 1
    } in
    distance >= swh_min_len[swh_col_sums[c]]
    /\
    distance <= swh_max_len[swh_col_sums[c]]
  );


%%%%%%%%% Sandwich assertion %%%%%%%%%

constraint sandwich -> 
  exists(r in INDEX_1D) (occurs(swh_row_sums[r]))
  \/
  exists(c in INDEX_1D) (occurs(swh_col_sums[c]));

%%%%%%%%% Solve statement %%%%%%%%%

solve :: seq_search([
         int_search(
           % positions of 1 and 9 in rows with clues
           [ row_pos[r, 1] | r in INDEX_1D where occurs(swh_row_sums[r]) ] ++
           [ row_pos[r, 9] | r in INDEX_1D where occurs(swh_row_sums[r]) ] ++
           % positions of 1 and 9 in columns with clues
           [ col_pos[1, c] | c in INDEX_1D where occurs(swh_col_sums[c]) ] ++
           [ col_pos[9, c] | c in INDEX_1D where occurs(swh_col_sums[c]) ],
           first_fail,      % pick the most constrained position
           indomain_min,    % try left/top positions first
           complete
         ),
         int_search(
           [ grid[r, c] | r in INDEX_1D, c in INDEX_1D ],
           first_fail,
           indomain_min,
           complete
         )
       ])
       satisfy;

output [
  % optional blank line between horizontal block rows
  (if c = 1 /\ r > 1 /\ (r-1) mod block_size = 0 then "\n" else "" endif) ++
  % digit
  show(grid[r,c]) ++
  % spaces / line breaks to keep block layout between 3x3 blocks
  (if c = size then "\n"
   elseif c mod block_size = 0 then "  "
   else " " endif)
  | r in INDEX_1D, c in INDEX_1D
];
