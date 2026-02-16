# runs all the icr recipes and checks if they build successfully. This is a sanity check to make sure the recipes are correct and can be built without errors. It does not check if the built packages work correctly, but it is a good first step to catch any issues with the recipes themselves.import subprocess
import os
import subprocess

cwd = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
coble_path = os.path.join(cwd, "code", "coble")
recipe_path = os.path.join(cwd, "recipes")

def do_block(section, recipe):
    """Test that the old version of r that needs compiling runs."""
    args = [coble_path,
        "build",
        "--recipe",
        f"{recipe_path}/{section}/{recipe}/{recipe}.cbl",
        "--env",
        recipe,
        "--rebuild"
    ]
    print("Running command:", " ".join(args))
    result = subprocess.run(args, cwd=cwd, capture_output=True, text=True,shell=False)    
    print(result.stdout)
    return result.returncode

def test_ok():
    assert 0 == 0

def test_360():
    success = do_block("utils", "r-360-conda")        
    assert success == 0   

def test_362():
    success = do_block("utils", "r-362-conda")    
    assert success == 0   

def test_443():
    success = do_block("utils", "r-443-conda")    
    assert success == 0   

def test_452():
    success = do_block("utils", "r-452-conda")    
    assert success == 0   

if __name__ == "__main__":        
    test_360()
    #test_362()
    #test_443()
    #test_452()
    #test_nightly()