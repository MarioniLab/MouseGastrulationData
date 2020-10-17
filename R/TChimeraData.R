#' T chimera data
#'
#' Obtain the processed or raw counts for the T chimeric mouse embryo dataset.
#'
#' @param type String specifying the type of data to obtain, see Details.
#' Default behaviour is to return processed data.
#' @param samples Integer or character vector specifying the samples for which data (processed or raw) should be obtained.
#' If \code{NULL} (default), data are returned for all QC-passing (fourteen) samples.
#'
#' @return 
#' If \code{type="processed"}, a \linkS4class{SingleCellExperiment} is returned containing processed data from selected samples
#'
#' If \code{type="raw"}, a \linkS4class{List} of SingleCellExperiments is returned,
#' each containing the raw counts for a single sample.
#' List elements are named after the corresponding sample.
#' 
#' @details
#' This function downloads the data for the T chimera experiment from Guibentif et al. (2020).
#' The dataset contains sixteen 10X Genomics samples from sets of embryo pools:
#' \itemize{
#' \item Sample 1: E8.5 injected cells (tomato positive), pool 1
#' \item Sample 2: E8.5 host cells (tomato negative), pool 1
#' \item Sample 3: E7.5 injected cells (tomato positive), pool 2
#' \item Sample 4: E7.5 host cells (tomato negative), pool 2
#' \item Sample 5: E8.5 injected cells (tomato positive), pool 3
#' \item Sample 6: E8.5 host cells (tomato negative), pool 3
#' \item Sample 7: E8.5 injected cells (tomato positive), pool 4
#' \item Sample 8: E8.5 host cells (tomato negative), pool 4
#' \item Sample 9: E8.5 injected cells (tomato positive), pool 5
#' \item Sample 10: E8.5 host cells (tomato negative), pool 5
#' \item Sample 11: E7.5 injected cells (tomato positive), pool 6
#' \item Sample 12: E7.5 host cells (tomato negative), pool 6
#' \item Sample 13: E7.5 injected cells (tomato positive), pool 7
#' \item Sample 14: E7.5 host cells (tomato negative), pool 7
#' \item Sample 15: E7.5 injected cells (tomato positive), pool 8
#' \item Sample 16: E7.5 host cells (tomato negative), pool 8
#' }
#' Samples from the same pool are paired in the experimental design.
#' Each pool is a biological replicate.
#' Samples 3 and 4 were excluded from analyses, as in these chimeras host cells seemed to form only ExE ectoderm.
#' The data is available to download if you like, but will not be fetched by default.
#' 
#' In the processed data, cell-containing libraries have already been identified in each sample
#' using the \code{emptyDrops} function from \pkg{DropletUtils}.
#' The count matrix contains the raw count vectors for the cells called from all samples in this manner.
#' Size factors were computed using the \code{computeSumFactors} function from \pkg{scran}.
#' The column metadata for called cells contains:
#' \describe{
#' \item{\code{cell}:}{Character, unique cell identifier across all samples.}
#' \item{\code{barcode}:}{Character, cell barcode from the 10X Genomics experiment.}
#' \item{\code{sample}:}{Integer, number of the sample from which the cell was taken.}
#' \item{\code{stage}:}{Character, stage of the mouse embryo at which the sample was taken.}
#' \item{\code{tomato}:}{Logical, whether this cell expressed td-Tomato during FACS.}
#' \item{\code{pool}:}{Integer, embryo pool from which cell derived; samples with same value are matched.}
#' \item{\code{stage.mapped}:}{Character, stage of the mouse embryo atlas to which the cell was mapped.}
#' \item{\code{celltype.mapped}:}{Character, cell type of the mouse embryo atlas to which the cell was mapped.}
#' \item{\code{closest.cell}:}{Character, closest cell in the atlas dataset (see \code{\link{EmbryoAtlasData}}) after MNN mapping.}
#' \item{\code{doub.density}:}{Numeric, output of (a now-outdated run of) \code{scran::doubletCells}, performed on each sample separately.}
#' \item{\code{trajectory.mapped}:}{Character, trajectory membership for somite/NMP formation.}
#' \item{\code{somite.subct.mapped}:}{Character, somite subcluster to which cells mapped.}
#' \item{\code{sizeFactor}:}{Numeric, cell sizefactor.}
#' }
#' #' Reduced dimension representations of the data are also available in the \code{reducedDims} slot of the SingleCellExperiment object.
#' 
#' The raw data contains the unfiltered count matrix for each sample, as generated directly from the CellRanger software.
#' Swapped molecules have been removed using \code{DropletUtils::swappedDrops}.
#' No filtering has been performed to identify cells.
#' This may be useful if performing analyses that need to account for the ambient RNA pool.
#' 
#' For both raw and processed data, the row metadata contains the Ensembl ID and MGI symbol for each gene.
#'
#' @author Aaron Lun, with modification by Jonathan Griffiths
#' @examples
#' t.data <- TChimeraData(samples = 1)
#'
#' t.data <- TChimeraData(type="processed", samples = 1)
#'
#' @references
#' Guibentif C, Griffiths JA et al. (2020). 
#' Diverse Routes towards Early Somites in the Mouse Embryo 
#' \emph{Developmental Cell} In press.
#'
#' @export
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom BiocGenerics sizeFactors
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom methods as
TChimeraData <- function(type=c("processed", "raw"), samples=c(1:2, 5:16)) {
    if(any(3:4 %in% samples))
        warning("You are downloading the QC-fail samples 3 and/or 4.")
    type <- match.arg(type)
    versions <- list(base="1.4.0")
    .getProcOrRaw("t-chimera", type, versions, samples, sample.options=as.character(seq_len(16)), sample.err="1:16")
}
