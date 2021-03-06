info <- data.frame(
    Title = sprintf("Atlas %s",
        c(sprintf("processed counts (sample %i)", c(1:10, 12:37)),
            "rowData",
            sprintf("colData (sample %i)", c(1:10, 12:37)),
            sprintf("size factors (sample %i)", c(1:10, 12:37)),
            sprintf("reduced dimensions (sample %i)", c(1:10, 12:37)),
            sprintf("raw counts (sample %i)", c(1:10, 12:37)),
            sprintf("processed spliced counts (sample %i)", c(1:10, 12:37)),
            sprintf("processed unspliced counts (sample %i)", c(1:10, 12:37)),
            sprintf("processed ambiguous counts (sample %i)", c(1:10, 12:37)))
    ),
    Description = sprintf("%s for the mouse embryo atlas single-cell RNA-seq dataset", 
        c(sprintf("Processed counts for sample %i", c(1:10, 12:37)),
            "Per-gene metadata for all samples",
            sprintf("Per-cell metadata for sample %i", c(1:10, 12:37)),
            sprintf("Size factors for sample %i", c(1:10, 12:37)),
            sprintf("Reduced dimensions for sample %i", c(1:10, 12:37)),
            sprintf("Raw counts for sample %i", c(1:10, 12:37)),
            sprintf("Processed spliced counts for sample %i", c(1:10, 12:37)),
            sprintf("Processed unspliced counts for sample %i", c(1:10, 12:37)),
            sprintf("Processed ambiguously spliced counts for sample %i", c(1:10, 12:37)))
    ),
    RDataPath = c(
        file.path("MouseGastrulationData", "atlas", "1.0.0", 
            c(sprintf("counts-processed-sample%i.rds", c(1:10, 12:37)),
                "rowdata.rds",
                sprintf("coldata-sample%i.rds", c(1:10, 12:37)),
                sprintf("sizefac-sample%i.rds", c(1:10, 12:37)),
                sprintf("reduced-dims-sample%i.rds", c(1:10, 12:37)),
                sprintf("counts-raw-sample%i.rds", c(1:10, 12:37)))),
        file.path("MouseGastrulationData", "atlas", "1.4.0", 
            c(sprintf("counts-spliced-sample%i.rds", c(1:10, 12:37)),
                  sprintf("counts-unspliced-sample%i.rds", c(1:10, 12:37)),
                  sprintf("counts-ambig-sample%i.rds", c(1:10, 12:37))))
    ),
    BiocVersion="3.12",
    Genome="mm10",
    SourceType="TXT",
    SourceUrl=c(
        rep(
            c("https://content.cruk.cam.ac.uk/jmlab/atlas_data"),
            c(36 * 5 + 1)),
        rep(
            c("https://content.cruk.cam.ac.uk/jmlab/atlas_data/velocyto"),
            c(36 * 3))
    ),
    SourceVersion=paste(
        c(rep("raw_counts.mtx.gz", 36), 
            "genes.tsv.gz",
            rep("meta.tab.gz", 36),
            rep("sizefactors.tab.gz", 36),
            rep("corrected_pcas.rds", 36),
            sprintf("sample_%i_unswapped.mtx.gz", c(1:10, 12:37)),
            sprintf("spliced-counts-processed-sample%i.mtx.gz", c(1:10, 12:37)),
            sprintf("unspliced-counts-processed-sample%i.mtx.gz", c(1:10, 12:37)),
            sprintf("ambiguous-counts-processed-sample%i.mtx.gz", c(1:10, 12:37))
        ),
        sep=";"
    ),
    Species="Mus musculus",
    TaxonomyId="10090",
    Coordinate_1_based=TRUE,
    DataProvider="Jonathan Griffiths",
    Maintainer="Jonathan Griffiths <jonathan.griffiths.94@gmail.com>",
    RDataClass="character",
    DispatchClass="Rds",
    stringsAsFactors = FALSE
)

write.csv(file="../../extdata/metadata-atlas.csv", info, row.names=FALSE)
