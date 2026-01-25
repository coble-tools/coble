#!/usr/bin/env Rscript

# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0 || args[1] %in% c("-h", "--help")) {
  cat("
Usage: Rscript visualize_network.R <packages.tsv> [OPTIONS]

Arguments:
  packages.tsv          Input TSV file with package information

Options:
  --output-prefix PREFIX           Prefix for output files (default: 'network')
  --output-path PATH               Output directory (default: './')
  --title TITLE                    Visualization title (default: 'Package Dependency Network')
  --background-color COLOR         Page background color (default: '#5c2323')
  --graph-background-color COLOR   Graph canvas background (default: '#b9d66a')

Example:
  Rscript visualize_network.R packages.tsv
  Rscript visualize_network.R packages.tsv --title 'My Project' --graph-background-color '#1a1a2e'
\n")
  quit(save = "no", status = 0)
}

input_file <- args[1]
output_path <- "./"
output_prefix <- "network"
viz_title <- "Package Dependency Network"
bg_color <- "#ffffff"
graph_bg_color <- "#dae6f0"

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

if (length(args) > 1 && any(args == "--title")) {
  idx <- which(args == "--title")
  if (idx < length(args)) viz_title <- args[idx + 1]
}

if (length(args) > 1 && any(args == "--background-color")) {
  idx <- which(args == "--background-color")
  if (idx < length(args)) bg_color <- args[idx + 1]
}

if (length(args) > 1 && any(args == "--graph-background-color")) {
  idx <- which(args == "--graph-background-color")
  if (idx < length(args)) graph_bg_color <- args[idx + 1]
}

cat(sprintf("Input: %s\n", input_file))
cat(sprintf("Output path: %s\n", output_path))
cat(sprintf("Output prefix: %s\n", output_prefix))
cat(sprintf("Title: %s\n", viz_title))
cat(sprintf("Page background: %s\n", bg_color))
cat(sprintf("Graph background: %s\n\n", graph_bg_color))

# Load required packages
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

# Add metadata with ICR color scheme
nodes <- nodes %>%
  left_join(pkgs %>% select(id = package, version, location), by = "id") %>%
  mutate(
    type = ifelse(!is.na(version), "main", "dependency"),
    color = case_when(
      # Main packages - ICR color scheme
      type == "main" & location == "CRAN" ~ "#E91E63",           # Bright pink - CRAN
      type == "main" & location == "Bioconductor" ~ "#AEEA00",   # Lime green - Bioconductor
      type == "main" & location == "CRAN-ARCHIVED" ~ "#FF6F00",  # Orange - Archived
      type == "main" & location == "LOCAL" ~ "#C62828",          # Dark red - Local
      type == "main" & grepl("^LOCAL-", location) ~ "#C62828",   # Dark red - Local variants (LOCAL-*)
      type == "main" ~ "#E91E63",                                # Bright pink - Other main
      # Dependencies - gray
      type == "dependency" ~ "#523b3b",                          # Gray - Dependencies
      TRUE ~ "#c7c7c7"                                            # Light gray - Unknown
    ),
    title = ifelse(!is.na(version),
                   paste0("<b>", id, "</b><br>",
                         "Version: ", version, "<br>",
                         "Location: ", location),
                   paste0("<b>", id, "</b><br>Dependency")),
    size = ifelse(type == "main", 25, 15),
    font.size = ifelse(type == "main", 18, 12),
    font.face = ifelse(type == "main", "bold", "normal")
  ) %>%
  arrange(label)  # Sort alphabetically for easier navigation in dropdown

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
vn <- visNetwork(nodes, edges, 
                 height = "800px", 
                 width = "100%",
                 main = list(text = viz_title, 
                            style = "font-size:24px; text-align:center; font-weight:bold; margin-bottom:20px;")) %>%
  visConfigure(enabled = TRUE, 
               filter = "physics") %>%
  visEdges(
    arrows = list(to = list(enabled = TRUE, scaleFactor = 1.2)),
    smooth = list(enabled = TRUE, type = "curvedCW", roundness = 0.2),
    color = list(color = "#888888", highlight = "#000000", opacity = 0.5)
  ) %>%
  visOptions(
    highlightNearest = list(enabled = TRUE, degree = 1, hover = TRUE),
    nodesIdSelection = TRUE,
    selectedBy = "location"
  ) %>%
  visLayout(randomSeed = 123) %>%
  visPhysics(
    enabled = TRUE,
    solver = "forceAtlas2Based",
    forceAtlas2Based = list(
      gravitationalConstant = -50
    ),
    stabilization = list(enabled = TRUE, iterations = 200)
  ) %>%
  visLegend(
    addNodes = list(
      list(label = "CRAN Package", color = "#E91E63", size = 15, font = list(size = 12)),
      list(label = "Bioconductor Package", color = "#AEEA00", size = 15, font = list(size = 12)),
      list(label = "Archived Package", color = "#FF6F00", size = 15, font = list(size = 12)),
      list(label = "Local/github Package", color = "#C62828", size = 15, font = list(size = 12)),
      list(label = "Dependency", color = "#523b3b", size = 15, font = list(size = 12))
    ),
    useGroups = FALSE,
    position = "left",
    ncol = 1
  ) %>%
  visInteraction(navigationButtons = TRUE, keyboard = TRUE)

# Save and add custom CSS + auto-open physics controls
output_html <- paste0(output_path, "/", output_prefix, "_interactive.html")
visSave(vn, output_html)

# Read the HTML file and inject custom CSS + JavaScript
html_content <- readLines(output_html)

# Find the </head> tag and insert custom CSS before it
head_end <- grep("</head>", html_content)[1]

custom_code <- paste0('
<style>
  /* Set page background color */
  body {
    background-color: ', bg_color, ' !important;
    margin: 0;
    padding: 0;
  }
  
  /* Graph container with border and background */
  #mynetwork {
    width: 100% !important;
    height: 800px !important;
    background-color: ', graph_bg_color, ' !important;
    border: 3px solid #333 !important;
    border-radius: 8px !important;
    box-shadow: 0 4px 12px rgba(0,0,0,0.3) !important;
  }
  
  /* Target the actual canvas element inside the network */
  #mynetwork canvas {
    background-color: ', graph_bg_color, ' !important;
  }
  
  /* Also style the vis-network div */
  .vis-network {
    background-color: ', graph_bg_color, ' !important;
  }
  
  /* HIDE the configure button since panel auto-opens */
  .vis-configuration.vis-config-button {
    display: none !important;
  }
  
  /* Position configure panel at the bottom */
  .vis-configuration-wrapper {
    display: block !important;
    position: fixed !important;
    left: 10px !important;
    top: auto !important;
    bottom: 10px !important;
    right: 10px !important;
    width: auto !important;
    max-width: calc(100vw - 20px) !important;
    max-height: 200px !important;
    overflow-y: auto !important;
    overflow-x: auto !important;
    background: rgba(65, 57, 57, 0.85) !important;
    border: 1px solid #310303 !important;
    border-radius: 5px !important;
    padding: 10px !important;
    box-shadow: 0 3px 8px rgba(0,0,0,0.3) !important;
    z-index: 100 !important;
    color: yellow !important;
  }
  
  .vis-configuration-wrapper .vis-config-item {
    margin-bottom: 8px !important;
  }
  
  .vis-configuration-wrapper label {
    color: grey !important;
  }
  
  .vis-configuration-wrapper .vis-config-label {
    color: grey !important;
  }
</style>
<script>
  // Force the configure panel to be visible
  window.addEventListener("load", function() {
    setTimeout(function() {
      var configWrapper = document.querySelector(".vis-configuration-wrapper");
      if (configWrapper) {
        configWrapper.style.display = "block";
      }
    }, 500);
  });
</script>
')

html_content <- c(html_content[1:(head_end-1)], custom_code, html_content[head_end:length(html_content)])
writeLines(html_content, output_html)

cat(sprintf("✓ Saved: %s\n", output_html))

# Save statistics
output_stats <- paste0(output_path, "/", output_prefix, "_stats.txt")
sink(output_stats)
cat("=== Network Statistics ===\n")
cat(sprintf("Title: %s\n", viz_title))
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
cat(sprintf("   - Title: '%s'\n", viz_title))
cat("   - Physics controls always visible at the BOTTOM\n")
cat("   - Arrows show: Package → Dependency\n")
cat("   - ICR Color Scheme:\n")
cat("     🌸 Pink = CRAN | 🍋 Lime = Bioconductor | 🟠 Orange = Archived | 🔴 Red = Local | ⚫ Gray = Dependencies\n")
cat("   - Click nodes to highlight connections\n")
cat("   - Use dropdown to select nodes\n")
cat("   - Drag to rearrange\n")
cat("   - Scroll to zoom\n")