import subprocess
import os
cwd = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))

# code/coble build --recipe tests/fixtures/old.cbl --env old --rebuild

def do_block(block):
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'tests/github/bashes/tests_set2_small.sh', block
    ], cwd=cwd, capture_output=True, text=True,shell=False)    
    print(result.stdout)
    return result.returncode

def test_fail():
    success = do_block("fail")
    assert success != 0
def test_small():
    success = do_block("small")
    assert success == 0

if __name__ == "__main__":    
    test_small()
    
    