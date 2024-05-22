library(DiffGraph)
rm(list = ls())

# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)
print(length(args))  # Add this line to check the number of arguments
print(args)  # Add this line to check all arguments received

# Check if the correct number of arguments is provided
if (length(args) < 2) {
  stop("Usage: Rscript script.R <output_directory> -c <covType>")
}

# Extract output directory and covariance type
output_directory <- args[1]
covType_index <- which(args == "-c") + 1
if (length(covType_index) != 1) {
  stop("Usage: Rscript script.R <output_directory> -c <covType>")
}
covType <- args[covType_index]

# Print output directory and covariance type for verification
print(output_directory)
print(covType)

#1. Identify differential network between breast cancer subtypes using Dtrace with covType
data(TCGA.BRCA)
X <- TCGA.BRCA$X[1,]
dtrace.results <- Dtrace(X, 0.45, covType = covType)
net.dtrace <- dtrace.results$Delta.graph.connected

# Visualize the estimated differential network in an interactive manner.
tkid <- tkplot(net.dtrace, vertex.size = degree(net.dtrace) * 1.5, layout = layout_with_fr, 
               vertex.color = "red", vertex.label.cex = 0.8, edge.width = 1.5, edge.color = "orange")

# Visualize the estimated differential network in a non-interactive manner.                
# Grab the coordinates from tkplot
l.dtrace <- tkplot.getcoords(tkid)
plot(net.dtrace, layout = l.dtrace, vertex.size = degree(net.dtrace) * 1.5, vertex.color = "red", 
     vertex.label.cex = 0.9, edge.width = 1.5, edge.color = "orange")

# Save the graph as PNG in the output directory
png_file <- paste0(output_directory, "/differential_network.png")
png(png_file)
plot(net.dtrace, layout = l.dtrace, vertex.size = degree(net.dtrace) * 1.5, vertex.color = "red", 
     vertex.label.cex = 0.9, edge.width = 1.5, edge.color = "orange")
dev.off()
