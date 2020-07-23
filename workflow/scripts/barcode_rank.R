message("Started")

#
# Manage script inputs
#

quants_mat_file <- snakemake@input[["quants"]]
plot_file <- snakemake@output[[1]]

#
# Manage R packages
#

library(tidyverse)
library(tximport)
library(DelayedMatrixStats)
library(cowplot)
library(sessioninfo)

#
# Main script
#

txi <- tximport::tximport(files = quants_mat_file, type = "alevin")

plot <- tibble(
    barcode = colnames(txi$counts),
    total = DelayedMatrixStats::colSums2(txi$counts)
) %>%
    arrange(desc(total)) %>%
    mutate(rank = row_number()) %>%
    ggplot() +
    geom_point(aes(rank, total)) +
    scale_y_log10() + scale_x_log10() +
    theme_cowplot()
ggsave(filename = plot_file, plot = plot)

#
# session info
#

sessioninfo::session_info()

message("Completed")
