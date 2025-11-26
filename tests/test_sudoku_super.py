import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SUPER_SOLVER = ROOT / "Sudoku" / "Super-Solver"


def test_ctc_500k_1_thermo():
    """Run `minizinc sudoku-super.mzn ctc/500k/1-thermos.dzn` and check output."""
    expected_output = """grid = 
[| 8, 1, 2, 7, 9, 3, 4, 6, 5
 | 6, 4, 3, 2, 8, 5, 9, 7, 1
 | 7, 5, 9, 1, 4, 6, 2, 8, 3
 | 3, 6, 1, 4, 5, 7, 8, 9, 2
 | 5, 7, 8, 9, 6, 2, 3, 1, 4
 | 9, 2, 4, 3, 1, 8, 6, 5, 7
 | 2, 9, 6, 5, 3, 1, 7, 4, 8
 | 1, 8, 7, 6, 2, 4, 5, 3, 9
 | 4, 3, 5, 8, 7, 9, 1, 2, 6
 |];
----------"""
    result = subprocess.run(
        ["minizinc", "sudoku-super.mzn", "ctc/500k/1-thermo.dzn"],
        cwd=SUPER_SOLVER,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, (
        "MiniZinc returned a non-zero exit code.\n"
        f"stdout:\n{result.stdout}\n\nstderr:\n{result.stderr}"
    )
    assert result.stdout.strip() == expected_output.strip(), (
        "MiniZinc output did not match expected grid.\n"
        f"Expected:\n{expected_output}\n\nGot:\n{result.stdout}"
    )


def test_ctc_500k_2_cages():
    """Run `minizinc sudoku-super.mzn ctc/500k/2-cages.dzn` and check output."""
    expected_output = """grid = 
[| 4, 7, 8, 6, 9, 3, 5, 2, 1
 | 1, 3, 9, 5, 2, 8, 4, 6, 7
 | 6, 5, 2, 4, 7, 1, 9, 8, 3
 | 5, 2, 7, 8, 4, 9, 3, 1, 6
 | 3, 4, 1, 7, 6, 2, 8, 9, 5
 | 8, 9, 6, 1, 3, 5, 2, 7, 4
 | 2, 8, 4, 3, 1, 6, 7, 5, 9
 | 9, 1, 3, 2, 5, 7, 6, 4, 8
 | 7, 6, 5, 9, 8, 4, 1, 3, 2
 |];
----------"""
    result = subprocess.run(
        ["minizinc", "sudoku-super.mzn", "ctc/500k/2-cages.dzn"],
        cwd=SUPER_SOLVER,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, (
        "MiniZinc returned a non-zero exit code.\n"
        f"stdout:\n{result.stdout}\n\nstderr:\n{result.stderr}"
    )
    assert result.stdout.strip() == expected_output.strip(), (
        "MiniZinc output did not match expected grid.\n"
        f"Expected:\n{expected_output}\n\nGot:\n{result.stdout}"
    )


def test_ctc_500k_3_full_kropki():
    """Run `minizinc sudoku-super.mzn ctc/500k/3-full-kropki.dzn` and check output."""
    expected_output = """grid = 
[| 6, 5, 2, 9, 3, 8, 4, 1, 7
 | 9, 3, 7, 4, 5, 1, 6, 8, 2
 | 8, 1, 4, 7, 2, 6, 9, 3, 5
 | 4, 2, 1, 6, 9, 3, 5, 7, 8
 | 7, 9, 6, 8, 1, 5, 2, 4, 3
 | 5, 8, 3, 2, 4, 7, 1, 6, 9
 | 2, 6, 8, 5, 7, 4, 3, 9, 1
 | 3, 7, 5, 1, 6, 9, 8, 2, 4
 | 1, 4, 9, 3, 8, 2, 7, 5, 6
 |];
----------"""
    result = subprocess.run(
        ["minizinc", "sudoku-super.mzn", "ctc/500k/3-full-kropki.dzn"],
        cwd=SUPER_SOLVER,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, (
        "MiniZinc returned a non-zero exit code.\n"
        f"stdout:\n{result.stdout}\n\nstderr:\n{result.stderr}"
    )
    assert result.stdout.strip() == expected_output.strip(), (
        "MiniZinc output did not match expected grid.\n"
        f"Expected:\n{expected_output}\n\nGot:\n{result.stdout}"
    )
