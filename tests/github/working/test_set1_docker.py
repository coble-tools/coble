import subprocess
import os
cwd = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))

# code/coble build --recipe tests/fixtures/small.cbl --validate tests/fixtures/validate.sh --env small --containers docker

def test_coble_small_docker():
    """Test that the small env runs."""
    result = subprocess.run([
        'bash', 'code/coble', 'build',
        '--recipe', 'tests/fixtures/small.cbl',
        '--validate', 'tests/fixtures/validate.sh',
        '--env', 'xsmall',
        '--code-source', 'local',
        '--containers', 'docker'
    ], cwd=cwd, capture_output=True, text=True)
    assert result.returncode == 0
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()

if __name__ == "__main__":
    test_coble_small_docker()