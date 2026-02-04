import subprocess
import os


"""
pytest tests/github/test_circle.py -s
python tests/github/test_circle.py
"""

def file_diffs(file1, file2):
    """Compare two files line by line and return the differences."""
    diffs = []
    num_diff == 0
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

        for i in range(0, len(lines1)):
            lines1[i] = lines1[i].rstrip()
        for i in range(0, len(lines2)):
            lines2[i] = lines2[i].rstrip()

        print(f"Comparing files {file1} and {file2}")
        print(f"File 1 has {len(lines1)} lines; File 2 has {len(lines2)} lines")
        print("Showing difference:")
        print("-" * 40)
        print(lines1)
        print("-" * 40)
        print(lines2)
        print("-" * 40)

        # check specifically each line in 1 and if it is in 2 and vs vsa
        
        for ln1 in lines1[30:]:
            if ln1 not in lines2:
                print(f"Line in {file1} not in {file2}: '{ln1}'")
                num_diff += 1
        for ln2 in lines2[30:]:
            if ln2 not in lines1:
                print(f"Line in {file2} not in {file1}: '{ln2}'")
                num_diff += 1

        
        #max_lines = max(len(lines1), len(lines2))
        #for i in range(30,max_lines):
        #    line1 = lines1[i].rstrip() if i < len(lines1) else ''
        #    line2 = lines2[i].rstrip() if i < len(lines2) else ''
        #    if line1 != line2:
        #        diffs.append((i + 1, line1, line2))
    return num_diff
    
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

    num_diffs = file_diffs(freeze_1, freeze_2)
    print(num_diffs)

    assert result1.returncode == 0
    assert result2.returncode == 0
    assert num_diffs == 0
    
if __name__ == "__main__":
    test_coble_circle()