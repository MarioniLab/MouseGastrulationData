info <- data.frame(
    Title = sprintf("WT chimera %s", 
        c("processed counts", "rowData", "colData", "size factors", 
            sprintf("raw counts (sample %i)", seq_len(4)))
    ),
    Description = sprintf("%s for the WT chimeric mouse embryo single-cell RNA-seq dataset", 
        c("Processed count matrix", "Per-gene metadata", "Per-cell metadata", "Size factors",
            sprintf("Raw counts for sample %i", seq_len(4)))
    ),
    RDataPath = file.path("MouseGastrulationData", "wt-chimera", "1.0.0", 
        c("counts-processed-all.rds", "rowdata.rds", "coldata.rds", "sizefac.rds",
            sprintf("counts-raw-sample%i.rds", seq_len(4)))
    ),
    BiocVersion="3.10",
    Genome="mm10",
    SourceType="TXT",
    SourceUrl=rep(
        c("https://content.cruk.cam.ac.uk/jmlab/chimera_wt_data"),
        c(4)
    ),
    SourceVersion=paste(
        c("raw_counts.mtx.gz", "genes.tsv.gz", "meta.tab.gz", "sizefactors.tab.gz", 
            sprintf("sample_%i_unswapped.mtx.gz", seq_len(4))),
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

write.csv(file="../extdata/metadata-wt-chimera.csv", info, row.names=FALSE)
