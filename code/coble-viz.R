#!/usr/bin/env Rscript

# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0 || args[1] %in% c("-h", "--help")) {
  cat("
Usage: Rscript visualize_network.R <packages.tsv> [--output-prefix PREFIX] [--output-path PATH]

Arguments:
  packages.tsv          Input TSV file with package information
  --output-prefix       Prefix for output files (default: 'network')
  --output-path         Output directory (default: './')

Example:
  Rscript visualize_network.R packages.tsv
  Rscript visualize_network.R packages.tsv --output-prefix my_network --output-path ./results
\n")
  quit(save = "no", status = 0)
}

input_file <- args[1]
output_path <- "./"
output_prefix <- "network"

if (!file.exists(input_file)) {
  cat(sprintf("Error: File '%s' not found!\n", input_file))
  quit(save = "no", status = 1)
}

if (length(args) > 1 && any(args == "--output-prefix")) {
  idx <- which(args == "--output-prefix")
  if (idx < length(args)) output_prefix <- args[idx + 1]
}

if (length(args) > 1 && any(args == "--output-path")) {
  idx <- which(args == "--output-path")
  if (idx < length(args)) output_path <- args[idx + 1]
}

cat(sprintf("Input: %s\n", input_file))
cat(sprintf("Output path: %s\n", output_path))
cat(sprintf("Output prefix: %s\n\n", output_prefix))

# Only need these two packages (much easier to install!)
packages <- c("tidyverse", "visNetwork")
cat("Loading required packages...\n")
for(pkg in packages) {
  if(!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installing %s...\n", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org", quiet = TRUE)
    library(pkg, character.only = TRUE, quietly = TRUE)
  }
}

# Read data
cat(sprintf("Reading %s...\n", input_file))
pkgs <- read.table(input_file, sep = "\t", header = TRUE, 
                   stringsAsFactors = FALSE, quote = "")

# Parse dependencies
cat("Parsing dependencies...\n")
edges <- pkgs %>%
  select(from = package, deps = dependencies) %>%
  mutate(deps = strsplit(as.character(deps), ",\\s*")) %>%
  unnest(deps) %>%
  filter(!is.na(deps), deps != "", deps != "R") %>%
  mutate(to = str_trim(deps)) %>%
  select(from, to) %>%
  distinct()

cat(sprintf("Found %d packages with %d dependencies\n", nrow(pkgs), nrow(edges)))

# Create nodes
all_pkgs <- unique(c(edges$from, edges$to))
nodes <- data.frame(
  id = all_pkgs,
  label = all_pkgs,
  stringsAsFactors = FALSE
)

# Add metadata
nodes <- nodes %>%
  left_join(pkgs %>% select(id = package, version, location), by = "id") %>%
  mutate(
    type = ifelse(!is.na(version), "main", "dependency"),
    color = case_when(
      type == "main" ~ "#E41A1C",
      location == "CRAN" ~ "#377EB8", 
      location == "Bioconductor" ~ "#4DAF4A",
      TRUE ~ "#DDDDDD"
    ),
    title = ifelse(!is.na(version),
                   paste0("<b>", id, "</b><br>",
                         "Version: ", version, "<br>",
                         "Location: ", location),
                   paste0("<b>", id, "</b><br>Dependency")),
    size = ifelse(type == "main", 25, 15),
    font.size = ifelse(type == "main", 18, 12),
    font.face = ifelse(type == "main", "bold", "normal")
  )

# Calculate basic statistics
n_main <- sum(nodes$type == "main")
n_deps <- sum(nodes$type == "dependency")

# Count incoming dependencies for each package
dep_counts <- edges %>%
  group_by(to) %>%
  summarise(n_dependents = n()) %>%
  arrange(desc(n_dependents))

# Create interactive network
cat("Creating interactive network...\n")
vn <- visNetwork(nodes, edges, height = "800px", width = "100%") %>%
  visEdges(
    arrows = list(to = list(enabled = TRUE, scaleFactor = 1.2)),
    smooth = list(enabled = TRUE, type = "curvedCW", roundness = 0.2),
    color = list(color = "#888888", highlight = "#000000", opacity = 0.5)
  ) %>%
  visOptions(
    highlightNearest = list(enabled = TRUE, degree = 1, hover = TRUE),
    nodesIdSelection = TRUE,
    selectedBy = "type"
  ) %>%
  visLayout(randomSeed = 123) %>%
  visPhysics(
    solver = "forceAtlas2Based",
    forceAtlas2Based = list(gravitationalConstant = -50),
    stabilization = TRUE
  ) %>%
  visLegend(
    addNodes = list(
      list(label = "Main Package", color = "#E41A1C", size = 25, font = list(size = 18)),
      list(label = "Dependency", color = "#377EB8", size = 15, font = list(size = 12))
    ),
    useGroups = FALSE
  ) %>%
  visInteraction(navigationButtons = TRUE, keyboard = TRUE)

output_html <- paste0(output_path, "/", output_prefix, "_interactive.html")
visSave(vn, output_html)
cat(sprintf("✓ Saved: %s\n", output_html))

# Save statistics
output_stats <- paste0(output_path, "/", output_prefix, "_stats.txt")
sink(output_stats)
cat("=== Network Statistics ===\n")
cat(sprintf("Input file: %s\n", input_file))
cat(sprintf("Total packages: %d\n", nrow(nodes)))
cat(sprintf("Main packages: %d\n", n_main))
cat(sprintf("Dependencies: %d\n", n_deps))
cat(sprintf("Dependency relationships: %d\n", nrow(edges)))
cat("\nArrow direction: Package → Dependency\n")
cat("(An arrow from A to B means A depends on B)\n")

cat("\n=== Most Depended Upon Packages ===\n")
top_10 <- head(dep_counts, 10)
for(i in 1:nrow(top_10)) {
  cat(sprintf("%2d. %-20s (%d packages depend on it)\n",
              i, top_10$to[i], top_10$n_dependents[i]))
}
sink()

cat(sprintf("✓ Saved: %s\n", output_stats))

# Print stats to console
cat("\n")
cat(readLines(output_stats), sep = "\n")

cat(sprintf("\n✓ Done! Open %s in a browser.\n", output_html))
cat("   - Arrows show: Package → Dependency\n")
cat("   - Click nodes to highlight connections\n")
cat("   - Use dropdown to select nodes\n")
cat("   - Drag to rearrange\n")
cat("   - Scroll to zoom\n")