import subprocess
import os

def test_coble_help():
    """Test that the coble utility runs and shows help."""
    result = subprocess.run([
        'bash', 'code/coble', '--help'
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True)
    assert result.returncode == 0
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()


def test_coble_invalid():
    """Test that the small env runs."""
    result = subprocess.run([
        'bash', 'code/coble', 'build', '--recipe', 'invalid.cbl', '--env', 'x'
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True)
    assert result.returncode == 1
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()

def test_coble_small():
    """Test that the small env runs."""
    result = subprocess.run([
        'bash', 'code/coble', 'build', '--recipe', 'tests/fixtures/small.cbl', '--env', 'small'
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True)
    assert result.returncode == 0
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()