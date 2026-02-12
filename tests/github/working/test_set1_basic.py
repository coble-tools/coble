import subprocess#
import os
cwd = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
#print(f"Current working directory: {cwd}")


def test_coble_help():
    """Test that the coble utility runs and shows help."""
    result = subprocess.run([
        'bash', 'code/coble', '--help'
    ], cwd=cwd, capture_output=True, text=True)
    #print(result)
    assert result.returncode == 0
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()


def test_coble_invalid():
    """Test that the small env runs."""
    result = subprocess.run([
        'bash', 'code/coble', 'build', '--recipe', 'invalid.cbl', '--env', 'x'
    ], cwd=cwd, capture_output=True, text=True)
    assert result.returncode == 1
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()

def test_coble_small():
    """Test that the small env runs."""
    result = subprocess.run([
        'bash', 'code/coble', 'build', '--recipe', 'tests/fixtures/small.cbl', '--env', 'xxsmall'
    ], cwd=cwd, capture_output=True, text=True)
    assert result.returncode == 0
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()

if __name__ == "__main__":
    test_coble_help()