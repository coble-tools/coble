# Contribute your recipes!

If you have a recipe that you would like to contribute to the Coble project, please follow these guidelines:

## Naming and Structure
**Naming Convention:** Please encode your institution and then a project name in a recognisable format with a dash, eg "icr-sylver". You will then create a directory and cbl file in recipes like:  
`recipes/icr-sylver/icr-sylver.cbl`  

**Publication or pre-print:** The recipes are intended for academic papers in publication or pre-print for reproducibility. Please ensure that your recipe is associated with a relevant publication or pre-print and include a README.md that has the following info:
- Full reference to the publication or pre-print
- DOI or URL link to the publication or pre-print
- Link to the methods section / code availability section of the publication or pre-print
- A brief description of the recipe and its purpose
- Instructions on how to use the recipe
- Any additional information about the recipe that may be useful for users

## Testing in conda
Before submitting your recipe, please test it in a conda environment to ensure that it works as expected. Test the receip with the build command:
```bash
coble build -- recipe recipes/icr-sylver/icr-sylver.cbl --env icr-sylver-test
```
Two of the outputs from the test are required alongside the input recipe for the pull request:
```
recipes/
└── icr-sylver/
    ├── icr-sylver.cbl
    ├── icr-sylver_frozen.yaml
    └── icr-sylver_summary.txt
    └── README.md
    └── .dockerhub  (optional file to request dockerhub builds)
```
 These provide the full picture of reproducibility with logs timings and errors and versions and channels.

## Submission guidelines

1. **Fork the Repository**: Start by forking the Coble repository to your own GitHub account.
2. **Create a New Branch**: Create a new branch for your recipe contribution.
3. **Test Your Recipe**: Before submitting, make sure to test your recipe to ensure it works as expected.
4. **Add Your files****: Add your recipe file and other files in the `recipes/icr-sylver/` directory. Ensure that your recipe follows the existing format and conventions.
5. Indicate if you would like the recipe build on DOCKER HUB CI by including a file .dockerhub
6. **Submit a Pull Request**: Once you are satisfied with your recipe, submit a pull request to the main Coble repository. Provide a clear description of your recipe and any relevant details.
7. **Review Process**: Your pull request will be reviewed by the maintainers. They may provide feedback or request changes before merging.
8. **Reprodicibility achieved!**: Once your recipe is merged, celebrate your contribution to the COBLE community!
