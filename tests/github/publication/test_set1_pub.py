import subprocess
import os

cwd = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))

def do_pub_test():
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'tests/github/publication/commands.sh'],
        cwd=cwd, capture_output=True, text=True,shell=False)
    print(result.stdout)
    return result.returncode

def test_publication():
    success = do_pub_test()
    assert success == 0

if __name__ == "__main__":
    test_publication()
