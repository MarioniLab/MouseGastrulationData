#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom BiocGenerics sizeFactors
#' @importFrom BiocGenerics sizeFactors<-
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom S4Vectors List
#' @importFrom methods as
.getProcOrRaw <- function(host, type, samples, sample.options, sample.err) {
    hub <- ExperimentHub()
    #default to all samples
    if (is.null(samples)) {
        samples <- sample.options
    }
    #check for sample boundaries
    samples <- as.character(samples)
    if (!all(samples %in% sample.options) | length(samples)==0) {
        stop(sprintf("'samples' must be in %s", sample.err))
    }

    rowdata <- hub[hub$rdatapath==file.path(host, "rowdata.rds")][[1]]

    if (type=="processed"){
        sce <- SingleCellExperiment()
        for(i in samples){
            counts <- hub[hub$rdatapath==file.path(host, sprintf("counts-processed-sample%s.rds", i))][[1]]
            coldata <- hub[hub$rdatapath==file.path(host, sprintf("coldata-sample%s.rds", i))][[1]]
            sf <- hub[hub$rdatapath==file.path(host, sprintf("sizefac-sample%s.rds", i))][[1]]
            reducedDims <- hub[hub$rdatapath==file.path(host, sprintf("reduced-dims-sample%s.rds", i))][[1]]
            output <- SingleCellExperiment(
                list(counts=counts),
                colData=as(coldata, "DataFrame"),
                reducedDims=reducedDims
            )
            sizeFactors(output) <- sf
            if(i == samples[1]){
                sce <- output
            } else {
                sce <- SingleCellExperiment::cbind(sce, output)
            }
        }
        rowData(sce) <- rowdata
        return(sce)
    } else if (type == "raw") {
        output <- List()
        for (i in samples) {
            counts <- hub[hub$rdatapath==file.path(host, sprintf("counts-raw-sample%s.rds", i))][[1]]
            output[[i]] <- SingleCellExperiment(list(counts=counts), rowData=rowdata)
        }
        return(output)
    } else {
        stop("Incorrect 'type' provided.")
    }    
}
