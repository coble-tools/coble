# Motivation and Problem Statement

Building complex R and Python environments for scientific computing is a major challenge, especially on HPC systems. For large projects, it can take up to 8 hours to build an environment with over 200 libraries, each with their own dependencies. Every new version of R can change the dependency order, making the process unpredictable and fragile.

If an environment is lost or corrupted, it can take days to rebuild, causing significant delays in research. This is a critical issue for reproducible science, where the ability to recreate an environment exactly is essential for verifying results and sharing methods.

## What COBLE Solves
- **Automated, repeatable builds:** COBLE enables environments to be rebuilt on a regular basis, ensuring that the process is always testable and up-to-date.
- **Dependency management:** Handles complex dependency trees and changing package orders across R versions.
- **Disaster recovery:** Rapidly recreates environments if they are lost, minimizing downtime on HPC clusters.
- **Reproducibility:** Supports the core principle of reproducible science by making environments recreatable, not just once, but continuously.
- **Reusability:** By making the build scripts and resulting environments available, others can reuse and adapt them for their own work.
- **Containerization:** Builds Docker and Singularity images, making environments portable and shareable across different systems.

COBLE is designed to make robust, reproducible, and reusable scientific environments a reality, saving time and supporting best practices in computational research.

## Evolving Environments and Recipe Rationalization

A common use case is that a conda environment is built up incrementally over time. For reproducibility, it is essential that all library versions remain pinned—once a package is added, its version and the order of installation must not change. This ensures that the environment can always be recreated exactly as it was.

However, as new libraries are added, the environment can become less organized, and the installation order may become suboptimal. At this stage, you are effectively "locked in" to the current structure for that environment version.

When a new major version of R or Python is released, you have an opportunity to rationalize and restructure your recipe. This is the ideal time to revisit the order of installations, remove redundancies, and optimize the build process for clarity and maintainability. COBLE supports this workflow by making it easy to rebuild and test new environment recipes, while preserving the ability to reproduce historical builds exactly.

This approach balances strict reproducibility for existing environments with flexibility and best practices for future builds.