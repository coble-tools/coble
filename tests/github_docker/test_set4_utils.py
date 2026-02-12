import subprocess
import os

# code/coble build --recipe tests/fixtures/old.cbl --env old --rebuild

def do_block(path, block):
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'tests/github_docker/bashes/tests_docker.sh', path, block
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True,shell=False)    
    print(result.stdout)
    return result.returncode

def test_r_360():
    success = do_block("utils", "r-360")
    assert success == 0

def test_r_362():
    success = do_block("utils", "r-362")
    assert success == 0    

def test_r_452():
    success = do_block("utils", "r-452")
    assert success == 0

def test_r_nightly():
    success = do_block("utils", "r-nightly")
    assert success == 0

if __name__ == "__main__":    
    test_r_360()
    #test_r_362()
    #test_r_nightly()
    