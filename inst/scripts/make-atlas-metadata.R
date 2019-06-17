info <- data.frame(
    Title = sprintf("Atlas %s", 
        c("processed counts", "rowData", "colData", "size factors", "reduced dimensions",
            sprintf("raw counts (sample %i)", c(1:10, 12:37)))
    ),
    Description = sprintf("%s for the mouse embryo atlas single-cell RNA-seq dataset", 
        c("Processed count matrix", "Per-gene metadata", "Per-cell metadata", "Size factors", "Reduced dimensions",
            sprintf("Raw counts for sample %i", c(1:10, 12:37)))
    ),
    RDataPath = file.path("MouseGastrulationData", "atlas", "1.0.0", 
        c("counts-processed-all.rds", "rowdata.rds", "coldata.rds", "sizefac.rds", "reduced-dims.rds",
            sprintf("counts-raw-sample%i.rds", c(1:10, 12:37)))
    ),
    BiocVersion="3.10",
    Genome="mm10",
    SourceType="TXT",
    SourceUrl=rep(
        c("https://content.cruk.cam.ac.uk/jmlab/atlas_data"),
        c(41)
    ),
    SourceVersion=paste(
        c("raw_counts.mtx.gz", "genes.tsv.gz", "meta.tab.gz", "sizefactors.tab.gz", "corrected_pcas.rds",
            sprintf("sample_%i_unswapped.mtx.gz", c(1:10, 12:37))),
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

write.csv(file="../extdata/metadata-atlas.csv", info, row.names=FALSE)
