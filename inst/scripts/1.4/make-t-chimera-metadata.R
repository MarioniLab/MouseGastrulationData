info <- data.frame(
    Title = sprintf("T chimera %s", 
        c(sprintf("processed counts (sample %i)", seq_len(16)),
            "rowData",
            sprintf("colData (sample %i)", seq_len(16)),
            sprintf("size factors (sample %i)", seq_len(16)),
            sprintf("reduced dimensions (sample %i)", seq_len(16)),
            sprintf("raw counts (sample %i)", seq_len(16)))
    ),
    Description = sprintf("%s for the T chimeric mouse embryo single-cell RNA-seq dataset", 
        c(sprintf("Processed counts for sample %i", seq_len(16)),
            "Per-gene metadata for all samples",
            sprintf("Per-cell metadata for sample %i", seq_len(16)),
            sprintf("Size factors for sample %i", seq_len(16)),
            sprintf("Reduced dimensions for sample %i", seq_len(16)),
            sprintf("Raw counts for sample %i", seq_len(16)))
    ),
    RDataPath = file.path("MouseGastrulationData", "t-chimera", "1.4.0", 
        c(sprintf("counts-processed-sample%i.rds", seq_len(16)),
            "rowdata.rds",
            sprintf("coldata-sample%i.rds", seq_len(16)),
            sprintf("sizefac-sample%i.rds", seq_len(16)),
            sprintf("reduced-dims-sample%i.rds", seq_len(16)),
            sprintf("counts-raw-sample%i.rds", seq_len(16)))
    ),
    BiocVersion="3.11",
    Genome="mm10",
    SourceType="TXT",
    SourceUrl=rep(
        c("https://content.cruk.cam.ac.uk/jmlab/chimera_t_data"),
        16 * 5 + 1
    ),
    SourceVersion=paste(
        c(rep("raw_counts.mtx.gz", 16), 
            "genes.tsv.gz",
            rep("meta.tab.gz", 16),
            rep("sizefactors.tab.gz", 16),
            rep("corrected_pcas.rds", 16),
            sprintf("sample_%i_unswapped.mtx.gz", seq_len(16))),
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

write.csv(file="../../extdata/metadata-t-chimera.csv", info, row.names=FALSE)
