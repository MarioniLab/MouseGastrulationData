#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom BiocGenerics sizeFactors
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom methods as
getProcOrRaw <- function(host, type, raw.samples, raw.options, raw.err) {
    hub <- ExperimentHub()
    rowdata <- hub[hub$rdatapath==file.path(host, "rowdata.rds")][[1]]
    rowdata <- as(rowdata, "DataFrame")

    if (type=="processed") {
        counts <- hub[hub$rdatapath==file.path(host, "counts-processed-all.rds")][[1]]
        coldata <- hub[hub$rdatapath==file.path(host, "coldata.rds")][[1]]
        sf <- hub[hub$rdatapath==file.path(host, "sizefac.rds")][[1]]
        reducedDims <- hub[hub$rdatapath==file.path(host, "reduced-dims.rds")][[1]]
        output <- SingleCellExperiment(
            list(counts=counts), 
            rowData=rowdata, 
            colData=as(coldata, "DataFrame"),
            reducedDims=reducedDims
        )
        sizeFactors(output) <- sf

    } else {
        if (is.null(raw.samples)) {
            raw.samples <- raw.options
        }

        raw.samples <- as.character(raw.samples)
        if (!all(raw.samples %in% raw.options)) {
            stop(sprintf("'raw.samples' must be in %s", raw.err))
        }

        output <- List()
        for (i in raw.samples) {
            counts <- hub[hub$rdatapath==file.path(host, sprintf("counts-raw-sample%s.rds", i))][[1]]
            output[[i]] <- SingleCellExperiment(list(counts=counts), rowData=rowdata)
        }
    }

    output
}

