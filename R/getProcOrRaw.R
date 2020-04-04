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
        count_list <- lapply(samples, function(i){
            hub[hub$rdatapath==file.path(host, sprintf("counts-processed-sample%s.rds", i))][[1]]
        })
        coldata_list <- lapply(samples, function(i){
            hub[hub$rdatapath==file.path(host, sprintf("coldata-sample%s.rds", i))][[1]]
        })
        sf_list <- lapply(samples, function(i){
            hub[hub$rdatapath==file.path(host, sprintf("sizefac-sample%s.rds", i))][[1]]
        })
        reducedDims_list <- lapply(samples, function(i){
            hub[hub$rdatapath==file.path(host, sprintf("reduced-dims-sample%s.rds", i))][[1]]
        })
        combined_pca <- do.call(rbind, lapply(reducedDims_list, function(x) x$pca.corrected))
        combined_umap <- do.call(rbind, lapply(reducedDims_list, function(x) x$umap))
        sce <- SingleCellExperiment(
                assays=list(counts=do.call(Matrix::cbind, count_list)),
                colData=as(do.call(rbind, coldata_list), "DataFrame"),
                reducedDims=list(pca.corrected = combined_pca, umap = combined_umap),
                rowData=rowdata
            )
        sizeFactors(sce) <- do.call(c, sf_list)
        rownames(sce) <- rowData(sce)$ENSEMBL
        colnames(sce) <- colData(sce)$cell
        return(sce)
    } else if (type == "raw") {
        output <- List()
        for (i in samples) {
            counts <- hub[hub$rdatapath==file.path(host, sprintf("counts-raw-sample%s.rds", i))][[1]]
            output[[i]] <- SingleCellExperiment(list(counts=counts), rowData=rowdata)
            rownames(output[[i]]) <- rowData(output[[i]])$ENSEMBL
        }
        return(output)
    } else {
        stop("Incorrect 'type' provided.")
    }    
}
