pkgs <- c(
    "dagitty",
    "devtools",
    "IRkernel",
    "rstan",
    "tidyverse"
)

install.packages(pkgs, repos="https://cloud.r-project.org/", Ncpus=8, dependencies = TRUE)
