#### 
# Versatile function for different data types
####
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom SpatialExperiment SpatialExperiment 
#' @importFrom BiocGenerics sizeFactors
#' @importFrom BiocGenerics sizeFactors<-
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom S4Vectors List
#' @importFrom methods as
#' @importFrom SummarizedExperiment rowData
#' @importFrom SummarizedExperiment colData
.getData <- function(
    dataset,
    version,
    samples,
    sample.options,
    sample.err,
    rd_name="rowdata",
    cd_name="coldata",
    sf_name="sizefac",
    assays=list("counts" = "counts-processed"),
    dimred_name="reduced-dims",
    coords_name="spatial-coords"
){
    hub <- ExperimentHub()
    host <- file.path("MouseGastrulationData", dataset)
    #default to all samples
    if (is.null(samples)) {
        samples <- sample.options
    }
    #check for sample boundaries
    samples <- as.character(samples)
    if (!all(samples %in% sample.options) || length(samples)==0) {
        stop(sprintf("'samples' must be in %s", sample.err))
    }
    # Temporary function for data extraction
    EXTRACTOR <- function(target) {
        ver <- .fetch_version(version, target)
        lapply(samples, function(i){
            hub[hub$rdatapath==file.path(host, ver, sprintf("%s-sample%s.rds", target, i))][[1]]
        })
    }
    assay_list <- lapply(seq_along(assays), function(x){
        samp_list = EXTRACTOR(assays[[x]])
        do.call(cbind, samp_list)
    })
    names(assay_list) = names(assays)
    sce <- SingleCellExperiment(
        assays=assay_list
    )
    if(!is.null(rd_name)){
        ver <- .fetch_version(version, "rowdata")
        rowData(sce) <- hub[hub$rdatapath==file.path(host, ver, paste0(rd_name, ".rds"))][[1]]
    }
    if(!is.null(cd_name)){
        colData(sce) <- do.call(rbind, EXTRACTOR(cd_name))
    }
    if(!is.null(sf_name)){
        sizeFactors(sce) <- do.call(c, EXTRACTOR(sf_name))
    }
    if(!is.null(dimred_name)){
        dr_list <- EXTRACTOR(dimred_name)
        dr_types <- names(dr_list[[1]])
        reducedDims(sce) <- lapply(dr_types, function(x){
            do.call(rbind, lapply(dr_list, function(y) y[[x]]))
        })
    }
    if(!is.null(coords_name)){
        spatialCoords(sce) = EXTRACTOR(coords_name)
    }
    if("ENSEMBL" %in% names(rowData(sce))){
        rownames(sce) <- rowData(sce)$ENSEMBL
    }
    if("cell" %in% names(colData(sce))){
        colnames(sce) <- colData(sce)$cell
    }
    return(sce)
}
####
# Simpler interfaces for specific data types
####
.getRNAseqData <- function(dataset, type, version, samples, sample.options, sample.err, extra_assays=NULL){
    if(type == "processed"){ return(
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            rd_name="rowdata",
            cd_name="coldata",
            sf_name="sizefac",
            assays=c(list("counts" = "counts-processed"), extra_assays),
            dimred_name="reduced-dims",
            coords_name=NULL
        ))
    } else if (type == "raw"){ return(
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            rd_name="rowdata",
            cd_name=NULL,
            sf_name=NULL,
            assays=list("counts" = "counts-raw"),
            dimred_name=NULL,
            coords_name=NULL
        ))
    }
}

.getSeqFISHData <- function(dataset, type, version, samples, sample.options, sample.err){
    if(type == "actual"){
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            rd_name="rowdata",
            cd_name="coldata",
            sf_name="sizefac",
            assays=list("counts" = "counts-processed", "molecules" = "molecules-processed"),
            dimred_name="reduced-dims",
            coords_name="spatial-coords"
        ))
    } else if (type == "imputed"){
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            rd_name="rowdata-imputed",
            cd_name="coldata",
            sf_name=NULL,
            assays=list("imputed_logcounts" = "logcounts-imputed"),
            dimred_name=NULL,
            coords_name="spatial-coords"
        ))
    }
}

#from Aaron Lun's celldex with modification
#for consistent usage in-package, use "base" as element 1, and use field as the 
# strings supplied to "*_name" to programmatically identify the right version
.fetch_version <- function(version, field) {
    opt <- version[[field]]
    if (is.null(opt)) {
        version[[1]]
    } else {
        opt
    }
}
