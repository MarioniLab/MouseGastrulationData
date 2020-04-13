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
    if (!all(samples %in% sample.options) || length(samples)==0) {
        stop(sprintf("'samples' must be in %s", sample.err))
    }

    rowdata <- hub[hub$rdatapath==file.path(host, "rowdata.rds")][[1]]

    if (type=="processed"){
        # Temporary function for data extraction
        EXTRACTOR <- function(target) {
            lapply(samples, function(i){
                hub[hub$rdatapath==file.path(host, sprintf("%s-sample%s.rds", target, i))][[1]]
            })
        }
        count_list <- EXTRACTOR("counts-processed")
        coldata_list <- EXTRACTOR("coldata")
        sf_list <- EXTRACTOR("sizefac")
        reducedDims_list <- EXTRACTOR("reduced-dims")

        # Handle data with different reducedDim names
        reducedDims_names = names(reducedDims_list[[1]])
        reducedDims_combined = lapply(reducedDims_names, function(x){
            do.call(rbind, lapply(reducedDims_list, function(y) y[[x]]))
        })
        names(reducedDims_combined) = reducedDims_names

        sce <- SingleCellExperiment(
                assays=list(counts=do.call(cbind, count_list)),
                colData=as(do.call(rbind, coldata_list), "DataFrame"),
                reducedDims=reducedDims_combined,
                rowData=rowdata
            )
        sizeFactors(sce) <- unlist(sf_list)
        rownames(sce) <- SingleCellExperiment::rowData(sce)$ENSEMBL
        colnames(sce) <- SingleCellExperiment::colData(sce)$cell
        return(sce)
    } else if (type == "raw") {
        output <- List()
        for (i in samples) {
            counts <- hub[hub$rdatapath==file.path(host, sprintf("counts-raw-sample%s.rds", i))][[1]]
            output[[i]] <- SingleCellExperiment(list(counts=counts), rowData=rowdata)
            rownames(output[[i]]) <- SingleCellExperiment::rowData(output[[i]])$ENSEMBL
        }
        return(output)
    } else {
        stop("Incorrect 'type' provided.")
    }    
}
