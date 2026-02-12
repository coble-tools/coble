import subprocess
import os
cwd = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
# code/coble build --recipe tests/fixtures/old.cbl --env old --rebuild

def do_block(path, block):
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'tests/github/bashes/tests_set3.sh', path, block
    ], cwd=cwd, capture_output=True, text=True,shell=False)    
    print(result.stdout)
    return result.returncode


def test_carbine():
    success = do_block("icr", "carbine")    
    assert success == 0    

if __name__ == "__main__":    
    test_carbine()
    
