info <- data.frame(
    Title = sprintf("WT chimera %s", 
        c(sprintf("processed counts (sample %i)", seq_len(10)),
            "rowData",
            sprintf("colData (sample %i)", seq_len(10)),
            sprintf("size factors (sample %i)", seq_len(10)),
            sprintf("reduced dimensions (sample %i)", seq_len(10)),
            sprintf("raw counts (sample %i)", seq_len(10)))
    ),
    Description = sprintf("%s for the WT chimeric mouse embryo single-cell RNA-seq dataset", 
        c(sprintf("Processed counts for sample %i", seq_len(10)),
            "Per-gene metadata for all samples",
            sprintf("Per-cell metadata for sample %i", seq_len(10)),
            sprintf("Size factors for sample %i", seq_len(10)),
            sprintf("Reduced dimensions for sample %i", seq_len(10)),
            sprintf("Raw counts for sample %i", seq_len(10)))
    ),
    RDataPath = file.path("MouseGastrulationData", "wt-chimera", "1.0.0", 
        c(sprintf("counts-processed-sample%i.rds", seq_len(10)),
            "rowdata.rds",
            sprintf("coldata-sample%i.rds", seq_len(10)),
            sprintf("sizefac-sample%i.rds", seq_len(10)),
            sprintf("reduced-dims-sample%i.rds", seq_len(10)),
            sprintf("counts-raw-sample%i.rds", seq_len(10)))
    ),
    BiocVersion="3.10",
    Genome="mm10",
    SourceType="TXT",
    SourceUrl=rep(
        c("https://content.cruk.cam.ac.uk/jmlab/chimera_wt_data"),
        10 * 5 + 1
    ),
    SourceVersion=paste(
        c(rep("raw_counts.mtx.gz", 10), 
            "genes.tsv.gz",
            rep("meta.tab.gz", 10),
            rep("sizefactors.tab.gz", 10),
            rep("corrected_pcas.rds", 10),
            sprintf("sample_%i_unswapped.mtx.gz", seq_len(10))),
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

write.csv(file="../../extdata/metadata-wt-chimera.csv", info, row.names=FALSE)
