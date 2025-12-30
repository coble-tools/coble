# Motivation and Problem Statement

Building complex R and Python environments for scientific computing is a major challenge.

Scientific reprodicibility is a known crisis and the environments in which code runs are hard to reproduce. Despite the best intentions of the authors, versions become out of date, rely on unspecified dependencies, are archived, disappear, seemed obvious to the authors but not others that they resided in r-forge rather than cran... Being able to reproduce an environment from a publication's methods section or from a code repositiry would considerably enhance people's experience of working with, and reproducing, other's code.

Additionally, for a lab's own environment, and especially on HPC systems, it can take up to 8 hours to build an environment with over 200 libraries, each with their own dependencies. Every new version of R can change the dependency order, making the process unpredictable and fragile. If an environment is lost or corrupted, it can take days to rebuild, causing significant delays in research. 

These are critical issues for reproducible science, where the ability to recreate an environment exactly from a publication or within a lab is essential for verifying results and sharing methods.

## What COBLE Solves
- **One step creation of mixed conda environment from cbl spec:** COBLE enables environments to be rebuilt with a minimum user-friendly spec, prompting for any errors so they can be corrected quickly.
- **Repeatable builds:** COBLE enables environments to be rebuilt on a regular basis, ensuring that the process is always testable and up-to-date.
- **Dependency management:** Handles complex dependency trees and changing package orders across R versions.
- **Disaster recovery:** Rapidly recreates environments if they are lost, minimizing downtime on HPC clusters.
- **Reproducibility:** Supports the core principle of reproducible science by making environments recreatable, not just once, but continuously.
- **Reusability:** By making the build scripts and resulting environments available, others can reuse and adapt them for their own work.
- **Containerization:** Builds Docker and Singularity images, making environments portable and shareable across different systems.

COBLE helps to make robust, reproducible, and reusable scientific environments, saving time and supporting best practices in computational research.

## Common use cases

### Building an environment from a publication
See the [SYLVER tutorial](recipes/sylver.md) for an example of taking the written info from a publication and rapidly building a working versioned environment.  The `find` directive helps to find the package source of given libraries and the ability to mix multiple package managers in one definitions smooths the time spent in creation.

### Evolving Environments and Recipe Rationalization
A common use case is that a conda environment is built up incrementally over time. For reproducibility, it is essential that all library versions remain pinned—once a package is added, its version and the order of installation must not change. This ensures that the environment can always be recreated exactly as it was.

However, as new libraries are added, the environment can become less organized, and the installation order may become suboptimal. At this stage, you are effectively "locked in" to the current structure for that environment version.

When a new major version of R or Python is released, you have an opportunity to rationalize and restructure your recipe. This is the ideal time to revisit the order of installations, remove redundancies, and optimize the build process for clarity and maintainability. COBLE supports this workflow by making it easy to rebuild and test new environment recipes, while preserving the ability to reproduce historical builds exactly.

This approach balances strict reproducibility for existing environments with flexibility and best practices for future builds.