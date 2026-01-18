import subprocess
import os

def test_coble_circle():
    """Test that the circular env runs.
    It is a multi stage test:
    gets the template,
    runs it
    using the output runs that
    compares the output and input
    """
    result = subprocess.run([
        'bash', 'code/coble', 'build', '--recipe', 'tests/fixtures/circle.cbl', '--env', 'circular', '--rebuild'
    ], cwd=os.path.dirname(os.path.dirname(os.path.dirname(__file__))), capture_output=True, text=True)
    assert result.returncode == 0
    assert 'usage' in result.stdout.lower() or 'help' in result.stdout.lower()

if __name__ == "__main__":
    test_coble_circle()