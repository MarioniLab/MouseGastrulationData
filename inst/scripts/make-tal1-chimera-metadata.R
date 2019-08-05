info <- data.frame(
    Title = sprintf("Tal1 chimera %s", 
        c(sprintf("processed counts (sample %i)", seq_len(4)),
            "rowData",
            sprintf("colData (sample %i)", seq_len(4)),
            sprintf("size factors (sample %i)", seq_len(4)),
            sprintf("reduced dimensions (sample %i)", seq_len(4)),
            sprintf("raw counts (sample %i)", seq_len(4)))
    ),
    Description = sprintf("%s for the Tal1 knock-out chimeric mouse embryo single-cell RNA-seq dataset", 
        c(sprintf("Processed counts for sample %i", seq_len(4)),
            "Per-gene metadata for all samples",
            sprintf("Per-cell metadata for sample %i", seq_len(4)),
            sprintf("Size factors for sample %i", seq_len(4)),
            sprintf("Reduced dimensions for sample %i", seq_len(4)),
            sprintf("Raw counts for sample %i", seq_len(4)))
    ),
    RDataPath = file.path("MouseGastrulationData", "tal1-chimera", "1.0.0", 
        c(sprintf("counts-processed-sample%i.rds", seq_len(4)),
            "rowdata.rds",
            sprintf("coldata-sample%i.rds", seq_len(4)),
            sprintf("sizefac-sample%i.rds", seq_len(4)),
            sprintf("reduced-dims-sample%i.rds", seq_len(4)),
            sprintf("counts-raw-sample%i.rds", seq_len(4)))
    ),
    BiocVersion="3.10",
    Genome="mm10",
    SourceType="TXT",
    SourceUrl=c(
        rep(
            "https://content.cruk.cam.ac.uk/jmlab/chimera_tal1_data",
            4 * 4 + 1),
        rep(
            "https://content.cruk.cam.ac.uk/jmlab/chimera_tal1_data/unfiltered",
        4)
    ),
    SourceVersion=paste(
        c(rep("raw_counts.mtx.gz", 4), 
            "genes.tsv.gz",
            rep("meta.tab.gz", 4),
            rep("sizefactors.tab.gz", 4),
            rep("corrected_pcas.rds", 4),
            sprintf("sample_%i_unswapped.mtx.gz", seq_len(4))),
        sep=";"
    ),
    Species="Mus musculus",
    TaxonomyId="10090",
    Coordinate_1_based=TRUE,
    DataProvider="Jonathan Griffiths",
    Maintainer="Aaron Lun <infinite.monkeys.with.keyboards@gmail.com>",
    RDataClass="character",
    DispatchClass="Rds",
    stringsAsFactors = FALSE
)

write.csv(file="../extdata/metadata-tal1-chimera.csv", info, row.names=FALSE)
