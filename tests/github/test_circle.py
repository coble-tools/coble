import subprocess
import os


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
        
        max_lines = max(len(lines1), len(lines2))
        for i in range(30,max_lines):
            line1 = lines1[i].rstrip() if i < len(lines1) else ''
            line2 = lines2[i].rstrip() if i < len(lines2) else ''
            if line1 != line2:
                diffs.append((i + 1, line1, line2))
    return diffs
    
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
    freeze_1 = 'tests/fixtures/circle_freeze.cbl'
    freeze_2 = 'tests/fixtures/circle_freeze_freeze.cbl'

    params1 = ['bash', 'code/coble', 'build', 
    '--recipe', input_file, 
    '--env', 'circular1']
    params2 = ['bash', 'code/coble', 'build', 
    '--recipe', freeze_1, 
    '--env', 'circular2']    
    if rebuild:
        params1.append('--rebuild')
        params2.append('--rebuild')
    result1 = subprocess.run(params1, cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True)
    result2 = subprocess.run(params2, cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True)

    diffs = file_diffs(freeze_1, freeze_2)
    print(diffs)

    assert result1.returncode == 0
    assert result2.returncode == 0
    assert len(diffs) == 0
    
if __name__ == "__main__":
    test_coble_circle()