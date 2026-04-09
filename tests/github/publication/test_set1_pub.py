import subprocess



def test_set1_pub():
    """Test that the publication env runs."""
    result = subprocess.run([
        'bash', 'code/coble', 'build',
        '--recipe', 'tests/fixtures/publication.cbl',
        '--env', 'publication1',
        '--rebuild'
    ], capture_output=True, text=True)
    print(result.stdout)
    assert result.returncode == 0


if __name__ == "__main__":
    test_set1_pub()
    