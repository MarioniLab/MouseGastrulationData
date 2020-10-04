#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom BiocGenerics sizeFactors
#' @importFrom BiocGenerics sizeFactors<-
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom S4Vectors List
#' @importFrom methods as
#' @importFrom SummarizedExperiment rowData
#' @importFrom SummarizedExperiment colData
.getProcOrRaw <- function(dataset, type, version, samples, sample.options, sample.err){
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
    #get rowdata
    ver <- .fetch_version(version, "rowData")
    rowdata <- hub[hub$rdatapath==file.path(host, ver, "rowdata.rds")][[1]]
    if(type=="processed"){
        # Temporary function for data extraction
        EXTRACTOR <- function(target, version_name) {
            ver <- .fetch_version(version, version_name)
            lapply(samples, function(i){
                hub[hub$rdatapath==file.path(host, ver, sprintf("%s-sample%s.rds", target, i))][[1]]
            })
        }
        count_list <- EXTRACTOR("counts-processed", "counts")
        assays <- list(counts=do.call(cbind, count_list))
        if("spliced" %in% names(version)){
            spliced_list <- EXTRACTOR("counts-spliced", "spliced")
            unspliced_list <- EXTRACTOR("counts-unspliced", "spliced")
            ambig_list <- EXTRACTOR("counts-ambig", "spliced")
            assays <- c(assays, list(
                spliced_counts=do.call(cbind, spliced_list),
                unspliced_counts=do.call(cbind, unspliced_list),
                ambiguous_counts=do.call(cbind, ambig_list)
            ))
        }

        coldata_list <- EXTRACTOR("coldata", "colData")
        sf_list <- EXTRACTOR("sizefac", "sizefactors")
        reducedDims_list <- EXTRACTOR("reduced-dims", "reducedDims")

        # Handle data with multiple reducedDims
        reducedDims_names <- names(reducedDims_list[[1]])
        reducedDims_combined <- lapply(reducedDims_names, function(x){
            do.call(rbind, lapply(reducedDims_list, function(y) y[[x]]))
        })
        names(reducedDims_combined) <- reducedDims_names

        sce <- SingleCellExperiment(
                assays=assays,
                colData=as(do.call(rbind, coldata_list), "DataFrame"),
                reducedDims=reducedDims_combined,
                rowData=rowdata
            )
        sizeFactors(sce) <- unlist(sf_list)
        rownames(sce) <- rowData(sce)$ENSEMBL
        colnames(sce) <- colData(sce)$cell
        return(sce)
    }  else if (type == "raw") {
        output <- List()
        ver <- .fetch_version(version, "raw_counts")
        for (i in samples) {
            counts <- hub[hub$rdatapath==file.path(host, ver, sprintf("counts-raw-sample%s.rds", i))][[1]]
            output[[i]] <- SingleCellExperiment(list(counts=counts), rowData=rowdata)
            rownames(output[[i]]) <- rowData(output[[i]])$ENSEMBL
        }
        return(output)
    } else {
        stop("Incorrect 'type' provided.")
    }   
}

#from Aaron Lun's celldex with modification
#for consistent usage in-package, use "base" as element 1, anything 
#with a different version gets an entry in version in .getProcOrRaw
#there should be in {counts,spliced,raw_counts,
#sizefactors,rowData,colData,reducedDims}
#spliced represents version for all spliced count measurements
.fetch_version <- function(version, field) {
    opt <- version[[field]]
    if (is.null(opt)) {
        version[[1]]
    } else {
        opt
    }
}
