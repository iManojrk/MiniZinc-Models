# MiniZinc Projects

This repository collects assorted MiniZinc example models (Sudoku variants, SEND+MORE puzzles, tutorials, etc.). Use the instructions below to get MiniZinc installed and run the models from the command line.

## Install MiniZinc

1. **Snap (Ubuntu and other Snap-enabled distros)**  

   ```zsh
   sudo snap install minizinc --classic
   ```  

   This provides the latest stable MiniZinc bundle with the standard solvers.
2. **Official downloads**  
   Visit <https://www.minizinc.org/software.html> for installers and packages tailored to Windows, macOS, and Linux distributions where Snap is not available. Follow the platform-specific instructions on that page, then ensure the `minizinc` executable is on your `PATH`.

## Run the models

1. Open a terminal in the repository root.
2. Run the desired model, optionally pairing it with a `.dzn` data file:

   ```zsh
   minizinc <model.mzn> [data.dzn]
   ```  

   For example, to run the Killer Sudoku model you might execute:  

   ```zsh
   minizinc Sudoku/Sudoku-Killer/sudoku-killer.mzn
   ```  

   Add a data file argument when a model expects one (e.g., tutorial puzzles with multiple instances). MiniZinc prints solutions to stdout; pass solver flags such as `--solver` if you need a specific backend.
