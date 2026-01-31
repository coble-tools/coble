import subprocess
import os

def test_coble_small_docker():
    """Test that the small env runs."""
    result = subprocess.run([
        'bash', 'code/coble', 'build', '--recipe', 'tests/fixtures/small.cbl', '--env', 'small', '--containers', 'docker'
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True)
    assert result.returncode == 0
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()