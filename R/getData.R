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
    rd.name="rowdata",
    cd.name="coldata",
    sf.name="sizefac",
    assays=list("counts" = "counts-processed"),
    dimred.name="reduced-dims",
    coords.name="spatial-coords",
    object.type=c("SingleCellExperiment", "SpatialExperiment")
){
    object.type <- match.arg(object.type)
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
    if(object.type == "SingleCellExperiment"){
        sce <- SingleCellExperiment(assays=assay_list)
    } else if (object.type == "SpatialExperiment"){
        sce <- SpatialExperiment(assays=assay_list)
    } else {
        stop("Unexpected object.type (not SCE/SpatialE)")
    }
    if(!is.null(rd.name)){
        ver <- .fetch_version(version, "rowdata")
        rowData(sce) <- hub[hub$rdatapath==file.path(host, ver, paste0(rd.name, ".rds"))][[1]]
    }
    if(!is.null(cd.name)){
        colData(sce) <- do.call(rbind, EXTRACTOR(cd.name))
    }
    if(!is.null(sf.name)){
        sizeFactors(sce) <- do.call(c, EXTRACTOR(sf.name))
    }
    if(!is.null(dimred.name)){
        dr_list <- EXTRACTOR(dimred.name)
        dr_types <- names(dr_list[[1]])
        reducedDims(sce) <- lapply(dr_types, function(x){
            do.call(rbind, lapply(dr_list, function(y) y[[x]]))
        })
    }
    if(!is.null(coords.name)){
        spatialCoords(sce) = EXTRACTOR(coords.name)
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
            rd.name="rowdata",
            cd.name="coldata",
            sf.name="sizefac",
            assays=c(list("counts" = "counts-processed"), extra_assays),
            dimred.name="reduced-dims",
            coords.name=NULL,
            object.type="SingleCellExperiment"
        ))
    } else if (type == "raw"){ return(
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            rd.name="rowdata",
            cd.name=NULL,
            sf.name=NULL,
            assays=list("counts" = "counts-raw"),
            dimred.name=NULL,
            coords.name=NULL,
            object.type="SingleCellExperiment"
        ))
    }
}

.getSeqFISHData <- function(dataset, type, version, samples, sample.options, sample.err, extra_assays=NULL){
    if(type == "actual"){
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            rd.name="rowdata",
            cd.name="coldata",
            sf.name="sizefac",
            assays=c(list("counts" = "counts-processed"), extra_assays),
            dimred.name="reduced-dims",
            coords.name="spatial-coords",
            object.type="SpatialExperiment"
        )
    } else if (type == "imputed"){
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            rd.name="rowdata-imputed",
            cd.name="coldata",
            sf.name=NULL,
            assays=list("imputed_logcounts" = "logcounts-imputed"),
            dimred.name=NULL,
            coords.name="spatial-coords",
            object.type="SpatialExperiment"
        )
    }
}

#from Aaron Lun's celldex with modification
#for consistent usage in-package, use "base" as element 1, and use field as the 
# strings supplied to "*.name" to programmatically identify the right version
.fetch_version <- function(version, field) {
    opt <- version[[field]]
    if (is.null(opt)) {
        version[[1]]
    } else {
        opt
    }
}
