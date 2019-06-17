info <- data.frame(
    Title = sprintf("Tal1 chimera %s", 
        c("processed counts", "rowData", "colData", "size factors", "reduced dimensions",
            sprintf("raw counts (sample %i)", seq_len(4)))
    ),
    Description = sprintf("%s for the Tal1 knock-out chimeric mouse embryo single-cell RNA-seq dataset", 
        c("Processed count matrix", "Per-gene metadata", "Per-cell metadata", "Size factors", "Reduced dimensions",
            sprintf("Raw counts for sample %i", seq_len(4)))
    ),
    RDataPath = file.path("MouseGastrulationData", "tal1-chimera", "1.0.0", 
        c("counts-processed-all.rds", "rowdata.rds", "coldata.rds", "sizefac.rds", "reduced-dims.rds",
            sprintf("counts-raw-sample%i.rds", seq_len(4)))
    ),
    BiocVersion="3.10",
    Genome="mm10",
    SourceType="TXT",
    SourceUrl=rep(
        c("https://content.cruk.cam.ac.uk/jmlab/chimera_tal1_data",
            "https://content.cruk.cam.ac.uk/jmlab/chimera_tal1_data/unfiltered"),
        c(5, 4)
    ),
    SourceVersion=paste(
        c("raw_counts.mtx.gz", "genes.tsv.gz", "meta.tab.gz", "sizefactors.tab.gz", "corrected_pcas_nodoubstripped.rds",
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
