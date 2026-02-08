import subprocess
import os

# code/coble build --recipe tests/fixtures/old.cbl --env old --rebuild

def do_block(block):
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'tests/github/tests.sh', block
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True,shell=False)    
    print(result.stdout)
    return result.returncode

def test_fail():
    success = do_block("fail")
    assert success != 0
def test_small():
    success = do_block("small")
    assert success == 0
#def test_docker():
#    success = do_block("docker")
#    assert success == 0
def test_carbine():
    success = do_block("carbine")
    assert success == 0
def test_sylver():
    success = do_block("sylver")
    assert success == 0
def test_deseq2():
    success = do_block("deseq2")
    assert success == 0
    
if __name__ == "__main__":
    #test_fail()
    #test_small()
    #test_docker()
    #test_carbine()
    test_sylver()
    #test_deseq2()
    