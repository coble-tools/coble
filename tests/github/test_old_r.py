import subprocess
import os

# code/coble build --recipe tests/fixtures/old.cbl --env old --rebuild

def test_old_r():
    """Test that the old version of r that needs compiling runs."""
    result = subprocess.run([
        'bash', 'code/coble', 'build', '--recipe', 'tests/fixtures/old.cbl', '--env', 'old'
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True)
    assert result.returncode == 0
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()

if __name__ == "__main__":
    test_old_r()
    