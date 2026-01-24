#!/usr/bin/env Rscript

# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0 || args[1] %in% c("-h", "--help")) {
  cat("
Usage: Rscript visualize_network.R <packages.tsv> [OPTIONS]

Arguments:
  packages.tsv          Input TSV file with package information

Options:
  --output-prefix PREFIX  Prefix for output files (default: 'network')
  --output-path PATH      Output directory (default: './')
  --title TITLE           Visualization title (default: 'Package Dependency Network')

Example:
  Rscript visualize_network.R packages.tsv
  Rscript visualize_network.R packages.tsv --title 'My Project Dependencies' --output-prefix my_network
\n")
  quit(save = "no", status = 0)
}

input_file <- args[1]
output_path <- "./"
output_prefix <- "network"
viz_title <- "Package Dependency Network"

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

cat(sprintf("Input: %s\n", input_file))
cat(sprintf("Output path: %s\n", output_path))
cat(sprintf("Output prefix: %s\n", output_prefix))
cat(sprintf("Title: %s\n\n", viz_title))

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
      type == "main" ~ "#a7176b",           # Red for main packages
      type == "dependency" ~ "#37b857",     # Blue for dependencies  
      TRUE ~ "#DDDDDD"                       # Gray fallback
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
vn <- visNetwork(nodes, edges, 
                 height = "800px", 
                 width = "100%",
                 main = list(text = viz_title, 
                            style = "font-size:24px; text-align:center; font-weight:bold; margin-bottom:20px;")) %>%
  visConfigure(enabled = TRUE, 
               filter = "physics",
               container = "configure-container") %>%
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
    useGroups = FALSE,
    position = "right",
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

custom_code <- '
<style>
  /* Style the configure button - small and subtle */
  .vis-configuration.vis-config-button {
    position: fixed !important;
    left: 10px !important;
    top: 150px !important;
    background: #2196F3 !important;
    color: white !important;
    padding: 6px 12px !important;
    border-radius: 4px !important;
    font-size: 12px !important;
    z-index: 101 !important;
    border: none !important;
    cursor: pointer !important;
  }
  
  /* Position configure panel on the left */
  .vis-configuration-wrapper {
    position: fixed !important;
    left: 10px !important;
    top: 190px !important;
    right: auto !important;
    width: 280px !important;
    max-height: calc(100vh - 210px) !important;
    overflow-y: auto !important;
    background: white !important;
    border: 1px solid #ddd !important;
    border-radius: 5px !important;
    padding: 10px !important;
    box-shadow: 0 3px 8px rgba(0,0,0,0.15) !important;
    z-index: 100 !important;
  }
  
  .vis-configuration-wrapper .vis-config-item {
    margin-bottom: 8px !important;
  }
  
  #mynetwork {
    width: 100% !important;
    height: 800px !important;
  }
</style>
<script>
  // Auto-open physics controls when page loads
  window.addEventListener("load", function() {
    setTimeout(function() {
      var configButton = document.querySelector(".vis-configuration.vis-config-button");
      if (configButton && configButton.textContent.includes("Configure")) {
        configButton.click();
      }
    }, 500);
  });
</script>
'

html_content <- c(html_content[1:(head_end-1)], custom_code, html_content[head_end:length(html_content)])
writeLines(html_content, output_html)

html_content <- c(html_content[1:(head_end-1)], custom_code, html_content[head_end:length(html_content)])
writeLines(html_content, output_html)

html_content <- c(html_content[1:(head_end-1)], custom_css, html_content[head_end:length(html_content)])
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
cat("   - Physics controls are on the LEFT (click 'Configure')\n")
cat("   - Arrows show: Package → Dependency\n")
cat("   - Click nodes to highlight connections\n")
cat("   - Use dropdown to select nodes\n")
cat("   - Drag to rearrange\n")
cat("   - Scroll to zoom\n")