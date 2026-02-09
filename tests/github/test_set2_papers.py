import subprocess
import os

# code/coble build --recipe tests/fixtures/old.cbl --env old --rebuild

def do_block(block):
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'tests/github/bashes/tests_set2_papers.sh', block
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True,shell=False)    
    print(result.stdout)
    return result.returncode

def test_deseq2():
    success = do_block("deseq2")
    assert success == 0

if __name__ == "__main__":    
    test_deseq2()
    