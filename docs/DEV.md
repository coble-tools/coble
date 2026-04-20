# Developing With COBLE

## The Test Suite
A comprehensive test suite is run in CI/CD when a pull request is made or a commit to main.
The tests are defined in tests/github

## Conda submission
The conda submission is made via a manual CI/CD, in `Actions` go to `Conda Release` -> `Run workflow` and choose the branch and new version.
Note we stay at 0, so a from 0.1.1 a major would be 0.2.0 and a minor would be 0.1.2.  
Conda requires a set of tests to be run, these are in `tests/conda`  

## Container submission
Made from actions in CI/CD, choose `Choose Arch GitHub/Docker Image (Manual)` -> `Run workflow` and specify the branch then 3 options: institution, name and architecture.

## Issues and Pull requests
Please raise an issue for any work to be done, and when ready create a draft poll request relevant to the issue e.g. issue-123-added-container.
The draft pull request alerts to the fact of the work and the files changed, and runs the tests. When ready confirm pull request and notify owner by requesting a review.  


