#' Mouse gastrulation joint ATAC/RNA data
#'
#' Obtain the processed or raw counts for the mouse gastrulation "multi-omics" dataset.
#'
#' @param type String specifying the type of data to obtain, see Details.
#' Default behaviour is to return all three data types.
#' @param samples Integer or character vector specifying the samples for which data (processed or raw) should be obtained.
#' If \code{NULL} (default), data are returned for all (11) samples.
#' 
#' @return 
#' If \code{type="all"}, a \linkS4class{SingleCellExperiment} object is returned containing processed data from selected samples for all data types.
#' RNA-seq data is in the primary assay slot, while the other data types are in the altExp slot.
#' No assay will occupy the default \code{counts} slot for clarity for the user.
#'
#' If \code{type="rna"}, \code{type="peaks"}, or \code{type="tss"}, a \linkS4class{SingleCellExperiment} object is returned containing information for a single data type.
#' Each assay will be in the primary \code{counts} slot.
#' RNA data corresponds to RNA-seq read counts.
#' Peak data corresponds to read counts from ATAC-seq peaks.
#' TSS data corresponds to (???)
#' 
#' @details
#' This function downloads the data for the embryo atlas from Argelaguet et al. (2022).
#' The dataset contains 11 10X Genomics multiome samples.
#' The metadata for each sample is as follows:
#' 
#' 
#' The column metadata contains:
#' \describe{
#' \item{\code{barcode}:}{Class: description of feature}
#' \item{\code{sample}:}{Class: description of feature}
#' \item{\code{nFeature_RNA}:}{Class: description of feature}
#' \item{\code{nCount_RNA}:}{Class: description of feature}
#' \item{\code{mitochondrial_percent_RNA}:}{Class: description of feature}
#' \item{\code{ribosomal_percent_RNA}:}{Class: description of feature}
#' \item{\code{stage}:}{Class: description of feature}
#' \item{\code{genotype}:}{Class: description of feature}
#' \item{\code{pass_rnaQC}:}{Class: description of feature}
#' \item{\code{sample_name}:}{Class: description of feature}
#' \item{\code{celltype.mapped}:}{Class: description of feature}
#' }
#' Reduced dimension representations of the data are also available in the \code{reducedDims} slot of the SingleCellExperiment object.
#' These are UMAPs calculated either across all the data, or per stage (\code{perstage}).
#' Those labelled either \code{rna} or \code{atac} alone were calculated from X; \code{rna_atac}-labelled UMAPs were calculated from the MOFA factors.
#' 
#' For the RNA and TSS gene score data, the row metadata contains the Ensembl ID and MGI symbol for each gene.
#' Unlike other datasets in MouseGastrulationData, the rownames for these objects are gene symbols.
#'
#' @author Aaron Lun, with modification by Jonathan Griffiths
#' @examples
#' RA_rna <- RAMultiomeData(samples=1, type = "rna")
#'
#' @references
#' Pijuan-Sala B, Griffiths JA, Guibentif C et al. (2019). 
#' A single-cell molecular map of mouse gastrulation and early organogenesis. 
#' \emph{Nature} 566, 7745:490-495.
#'
#' @export
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment
#' @importFrom SingleCellExperiment altExp<-
#' @importFrom BiocGenerics sizeFactors
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom methods as
RAMultiomeData <- function(type=c("all", "rna", "peaks", "tss"), samples=NULL) {
    type <- match.arg(type)
    versions <- list(base="1.12.0")
    if(type!="all"){
        return(.getSingleRA(type, s=samples, v = versions))
    } else {
        ass <- c("rna", "peaks", "tss")
        dat <- lapply(ass, .getSingleRA, s=samples, v=versions)
        newnames <- c(
            "rna" = "RNA_counts",
            "peaks" = "ATAC_peak_counts",
            "tss" = "TSS_gene_score")
        names(dat) <- newnames[ass] # more complex names for the assays
        return(.addAltExp(dat))
    }
}

.getSingleRA <- function(type=c("rna", "peaks", "tss"), s, v){
    type <- match.arg(type)
    name <- switch(type, rna="RA_rna", tss="RA_atac_tss", peaks="RA_atac_peaks")
    .getRNAseqData(name, type="processed", version=v, samples=s, sample.options=as.character(1:11), sample.err="1:11", ens_rownames=FALSE)
}

.addAltExp <- function(sce_list){
    if(length(sce_list)<2){
        stop("List of SCEs not long enough to combine")
    }
    #match order
    intersect <- Reduce(intersect, lapply(sce_list, colnames))
    for(i in seq_along(sce_list)){
        sce_list[[i]] = sce_list[[i]][, intersect]
    }
    #add altExps
    names(assays(sce_list[[1]])) <- names(sce_list)[1]
    for(i in seq_along(sce_list)[-1]){
        altExp(sce_list[[1]], names(sce_list)[i]) <- sce_list[[i]]
    }
    sce_list[[1]]
}
