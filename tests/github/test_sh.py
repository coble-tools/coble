import subprocess
import os

# code/coble build --recipe tests/fixtures/old.cbl --env old --rebuild

def do_block(block):
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'tests/github/tests.sh', block
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True,shell=False)    
    print(result.stdout)
    assert result.returncode == 0

def test_small():
    do_block("small")
def test_docker():
    do_block("docker")
    
if __name__ == "__main__":
    test_small()
    test_docker()
    