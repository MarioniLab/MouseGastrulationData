FROM bioconductor/bioconductor_docker:devel
RUN Rscript -e "BiocManager::install(c( \
    'MouseGastrulationData', \
    'ExperimentHub', \
    'SpatialExperiment', \
    'devtools', \
    'MultiAssayExperiment', \
    'zellkonverter' \
    ))"
# RUN Rscript -e "devtools::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories()); \
#     library(ArchR); \
#     ArchR::installExtraPackages()"
