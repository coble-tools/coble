import subprocess
import os
cwd = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))


"""
pytest tests/github/test_circle.py -s
python tests/github/test_circle.py
"""

def file_diffs(file1, file2):
    """Compare two files line by line and return the differences."""
    diffs = []
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

        print(f"Comparing files {file1} and {file2}")
        print(f"File 1 has {len(lines1)} lines; File 2 has {len(lines2)} lines")
        print("Showing difference:")
        print("-" * 40)
        print(lines1)
        print("-" * 40)
        print(lines2)
        print("-" * 40)

        diffs = 0
        for l1 in lines1[30:]:
            if l1 not in lines2:
                diffs += 1
                print(f"Line missing: {l1.strip()}")
        for l2 in lines2[30:]:
            if l2 not in lines1:
                diffs += 1
                print(f"Line missing: {l2.strip()}")
    return diffs, len(lines1[30:]), len(lines2[30:])

def test_coble_circle():
    """Test that the circular env runs.
    It is a multi stage test:
    gets the template,
    runs it
    using the output runs that
    compares the output and input
    """
    rebuild=True
    input_file = 'tests/fixtures/circle.cbl'
    freeze_1 = 'tests/fixtures/circle_export.cbl'
    freeze_2 = 'tests/fixtures/circle_export_export.cbl'

    params1 = ['bash', 'code/coble', 'build',
    '--recipe', input_file,
    '--env', 'circular1']
    params2 = ['bash', 'code/coble', 'build',
    '--recipe', freeze_1,
    '--env', 'circular2']
    if rebuild:
        params1.append('--rebuild')
        params2.append('--rebuild')
    result1 = subprocess.run(params1, cwd=cwd, capture_output=True, text=True)
    result2 = subprocess.run(params2, cwd=cwd, capture_output=True, text=True)

    diffs, lena, lenb = file_diffs(freeze_1, freeze_2)
    print(f"Length of file 1 (after line 30): {lena}")
    print(f"Length of file 2 (after line 30): {lenb}")

    assert result1.returncode == 0
    assert result2.returncode == 0
    assert diffs <= 1
    assert lena > 0
    assert lenb > 0

if __name__ == "__main__":
    test_coble_circle()