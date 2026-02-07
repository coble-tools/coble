import subprocess
import os

# code/coble build --recipe tests/fixtures/old.cbl --env old --rebuild

def test_sh():
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'tests/github/tests.sh'
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True,shell=False)    
    print(result.stdout)
    assert result.returncode == 0

    

if __name__ == "__main__":
    test_sh()
    