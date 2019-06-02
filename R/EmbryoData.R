#' Obtain the embryo timecourse Data
#'
#' Download and cache the embryo timecourse single-cell RNA-seq (scRNA-seq) dataset from ExperimentHub,
#' returning a \linkS4class{SingleCellExperiment} object for further use.
#'
#' @details
#' This function provides the embryo timecourse scRNA-seq data from Pijuan-Sala et al. (2019)
#' in the form of a \linkS4class{SingleCellExperiment} object. Doublets and
#' stripped nuclei were excluded.
#' 
#' Size factors were calculated using \linkS4class{scran}'s sum factor approach.
#'
#' Row data contains fields for the MGI gene symbol and Ensembl gene ID (v92).
#'
#' Column metadata contains technical information for each cell (sample.10x, sample.seq, embryo_pool),
#' timepoint information (stage), and celltype annotation (celltype).
#' 
#' The reduced dimension slot contains batch-corrected PCA coordinates for all cells together (corrected.pca),
#' and for cells at each timepoint (corrected.stagespecific.pca), and UMAP coordinates calculated from these
#' (umap, umap.stagespecific).
#'
#' @param stage A string, or vector of strings, that indicates a subset of timepoints to take from the
#' atlas dataset. Values provided must exactly match values in the column data of the data object.
#' @param hub An ExperimentHub object. This should likely be left as its default value.
#' 
#' @return A \linkS4class{SingleCellExperiment} object.
#'
#' @author Jonathan Griffiths
#'
#' @references
#' Pijuan-Sala et al. (2019). 
#' A single-cell molecular map of mouse gastrulation and early organogenesis.
#' \emph{Nature} 566, pp490-495.
#'
#' @examples
#' \dontrun{sce <- MouseGastrulationData()}
#' 
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment
MouseGastrulationData <- function(stage=NULL, hub=ExperimentHub()) {
    sce <- hub[hub$rdatapath=="MouseGastrulationDataSCE.rds"][[1]]
    #subset by stages
    if(!is.null(stage)){
    	if(!all(stage %in% colData(sce)$stage)){
    		stop("At least one supplied stage value does not match any possible value")
    	}
    	sce = sce[,colData(sce)$stage %in% stage]
    }
    sce
}
