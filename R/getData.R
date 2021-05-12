#### 
# Versatile function for different data types
####
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom SpatialExperiment SpatialExperiment 
#' @importFrom BumpyMatrix BumpyMatrix 
#' @importFrom BiocGenerics sizeFactors<-
#' @importFrom BiocGenerics cbind
#' @importFrom BiocGenerics rbind
#' @importFrom S4Vectors DataFrame
#' @importFrom S4Vectors List
#' @importFrom methods as
#' @importFrom SummarizedExperiment rowData
#' @importFrom SummarizedExperiment rowData<-
#' @importFrom SummarizedExperiment colData
#' @importFrom SummarizedExperiment colData<-
#' @importFrom SingleCellExperiment reducedDims<-
#' @importFrom SpatialExperiment spatialData<-
#' @importFrom SpatialExperiment spatialData
#' @importFrom SpatialExperiment spatialCoordsNames<-
.getData <- function(
    dataset,
    version,
    samples,
    sample.options,
    sample.err,
    names,
    object.type=c("SingleCellExperiment", "SpatialExperiment"),
    return.list=FALSE
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

    if(return.list){
        out <- lapply(samples, function(x){ .getData(dataset, version, x,
            sample.options, sample.err, names, object.type, return.list=FALSE)})
        names(out) <- samples
        return(out)
    }

    data = list()

    # Temporary function for data extraction
    EXTRACTOR <- function(target) {
        ver <- .fetch_version(version, target)
        lapply(samples, function(i){
            hub[hub$rdatapath==file.path(host, ver, sprintf("%s-sample%s.rds", target, i))][[1]]
        })
    }
    GET_ASSAYS <- function(ass){
        assay_list <- lapply(seq_along(ass), function(x){
            samp_list = EXTRACTOR(ass[[x]])
            do.call(cbind, samp_list)
        })
        names(assay_list) = names(ass)
        return(assay_list)
    }

    data$assays <- GET_ASSAYS(names$assays)
    
    if(!is.null(names$rd)){
        ver <- .fetch_version(version, "rowdata")
        data$rowData <- hub[hub$rdatapath==file.path(host, ver, paste0(names$rd, ".rds"))][[1]]
    }

    if(!is.null(names$cd)){
        #class change - atlas (at least) requires converting 
        #to "new" version of DataFrame to work
        cd <- do.call(rbind, lapply(EXTRACTOR(names$cd), DataFrame))
        #This is a patch for the Lohoff data due to SpatialExperiment changes
        #previously, sample_id was not required
        if(object.type == "SpatialExperiment" & 
            !"sample_id" %in% names(cd))
            cd$sample_id <- cd$embryo_pos_z
        data$colData <- cd
    }

    if(!is.null(names$dimred)){
        dr_list <- EXTRACTOR(names$dimred)
        dr_types <- names(dr_list[[1]])
        dr_sce <- lapply(dr_types, function(x){
            do.call(rbind, lapply(dr_list, function(y) y[[x]]))
        })
        names(dr_sce) <- dr_types
        data$reducedDims <- dr_sce
    }

    if(!is.null(names$coords)){
        data$spatialData <- do.call(rbind, EXTRACTOR(names$coords))
        coords <- c("x", "y", "z")
        data$spatialCoordsNames <- coords[coords %in% names(data$spatialData)]
    }

    command <- sprintf("%s(%s)",
        object.type,
        paste(sapply(names(data), function(x) paste0(x, "=data$", x)),
            collapse = ","))
    sce <- eval(parse(text = command))

    if(!is.null(names$sf)){
        sizeFactors(sce) <- do.call(c, EXTRACTOR(names$sf))
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
            names = list(
                assays=c(list("counts" = "counts-processed"), extra_assays),
                rd="rowdata",
                cd="coldata",
                sf="sizefac",
                dimred="reduced-dims"
            ),
            object.type="SingleCellExperiment"
        ))
    } else if (type == "raw"){ return(
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            names = list(
                assays=list("counts" = "counts-raw"),
                rd="rowdata"
            ),
            object.type="SingleCellExperiment",
            return.list=TRUE
        ))
    }
}

.getSeqFISHData <- function(dataset, type, version, samples, sample.options, sample.err, extra_assays=NULL){
    if(type == "observed"){
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            names = list(
                assays=c(list("counts" = "counts-processed"), extra_assays),
                rd="rowdata",
                cd="coldata",
                sf="sizefac",
                dimred="reduced-dims",
                coords="spatial-coords"
            ),
            object.type="SpatialExperiment"
        )
    } else if (type == "imputed"){
        .getData(
            dataset,
            version,
            samples,
            sample.options,
            sample.err,
            names = list(
                assays=list("imputed_logcounts" = "logcounts-imputed"),
                rd="rowdata-imputed",
                cd="coldata",
                coords="spatial-coords"
            ),
            object.type="SpatialExperiment"
        )
    }
}

#from Aaron Lun's celldex with modification
#for consistent usage in-package, use "base" as element 1, and use field as the 
# strings supplied to the names list to programmatically identify the right version
.fetch_version <- function(version, field) {
    opt <- version[[field]]
    if (is.null(opt)) {
        version[[1]]
    } else {
        opt
    }
}
