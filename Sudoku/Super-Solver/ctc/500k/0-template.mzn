include "../../sudoku-core.mzn";
include "../../sudoku-killer.mzn";
include "../../sudoku-thermo.mzn";
include "../../sudoku-german-whispers.mzn";
include "../../sudoku-kropki.mzn";
include "../../sudoku-knight.mzn";

% Solution

%%%%%%%%%% Sudoku parameters %%%%%%%%%%
size = 9;

clue = [|
    0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  | 0, 0, 0,   0, 0, 0,   0, 0, 0
  |];

%%%%%%%%%% Killer parameters %%%%%%%%%%

cage_count = 0;

cage_totals = [];

cage_cells = [];

%%%%%%%%%% Thermometer parameters %%%%%%%%%%

thermo_cells = [];

%%%%%%%% German Whispers parameters %%%%%%%%%

GW_cells = []; 

%%%%%%%% Partial Kropki parameters %%%%%%%%%

krp_cells = [];
