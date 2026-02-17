# runs all the icr recipes and checks if they build successfully. This is a sanity check to make sure the recipes are correct and can be built without errors. It does not check if the built packages work correctly, but it is a good first step to catch any issues with the recipes themselves.import subprocess
import os
import subprocess

DOCKER_MODE=True

cwd = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
coble_path = os.path.join(cwd, "code", "coble")
recipe_path = os.path.join(cwd, "recipes")


def do_block(section, recipe):    
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

def do_docker(section, recipe):    
    args = [coble_path,
        "build",
        "--recipe",
        f"{recipe_path}/{section}/{recipe}/{recipe}.cbl",
        "--env",
        recipe,
        "--containers",
        "docker,singularity",
        "--validate",
        f"{recipe_path}/{section}/{recipe}/validate/validate.sh",
    ]
    print("Running command:", " ".join(args))
    result = subprocess.run(args, cwd=cwd, capture_output=True, text=True,shell=False)            
    print(result.stdout)
    return result.returncode

def test_ok():
    assert 0 == 0
    
def test_carbine():
    if DOCKER_MODE:
        success = do_docker("icr", "carbine")    
    else:
        success = do_block("icr", "carbine")    
    assert success == 0   

def test_sylver():    
    if DOCKER_MODE:
        success = do_docker("icr", "sylver")    
    else:
        success = do_block("icr", "sylver")
    assert success == 0   


if __name__ == "__main__":        
    test_ok()