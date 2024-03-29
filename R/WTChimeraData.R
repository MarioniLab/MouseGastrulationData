#' WT chimera data
#'
#' Obtain the processed or raw counts for the WT chimeric mouse embryo dataset.
#'
#' @param type String specifying the type of data to obtain, see Details.
#' Default behaviour is to return processed data.
#' @param samples Integer or character vector specifying the samples for which data (processed or raw) should be obtained.
#' If \code{NULL} (default), data are returned for all (ten) samples.
#' @param Csparse.assays Logical indicating whether to convert assay matrices into the column major format that is more performant with contemporary software packages.
#' Default behaviour is to perform the conversion.
#'
#' @return 
#' If \code{type="processed"}, a \linkS4class{SingleCellExperiment} is returned containing processed data from selected samples
#'
#' If \code{type="raw"}, a \linkS4class{List} of SingleCellExperiments is returned,
#' each containing the raw counts for a single sample.
#' List elements are named after the corresponding sample.
#' 
#' @details
#' This function downloads the data for the WT chimera experiment from Pijuan-Sala et al. (2019).
#' The dataset contains ten 10X Genomics samples from sets of embryo pools:
#' \itemize{
#' \item Sample 1: E7.5 injected cells (tomato positive), pool 1
#' \item Sample 2: E7.5 host cells (tomato negative), pool 1
#' \item Sample 3: E7.5 injected cells (tomato positive), pool 2
#' \item Sample 4: E7.5 host cells (tomato negative), pool 2
#' \item Sample 5: E8.5 injected cells (tomato positive), pool 3
#' \item Sample 6: E8.5 host cells (tomato negative), pool 3
#' \item Sample 7: E8.5 injected cells (tomato positive), pool 4
#' \item Sample 8: E8.5 host cells (tomato negative), pool 4
#' \item Sample 9: E8.5 injected cells (tomato positive), pool 5
#' \item Sample 10: E8.5 host cells (tomato negative), pool 5
#' }
#' Samples from the same pool are paired in the experimental design.
#' Each pool is a biological replicate.
#' Only samples 5 and 6 were used in the analyses of Pijuan-Sala et al. (2019).
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
#' }
#' Reduced dimension representations of the data are also available in the \code{reducedDims} slot of the SingleCellExperiment object.
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
#' wt.data <- WTChimeraData(samples = 1)
#'
#' wt.data <- WTChimeraData(type="processed", samples = 1)
#'
#' @references
#' Pijuan-Sala B, Griffiths JA, Guibentif C et al. (2019). 
#' A single-cell molecular map of mouse gastrulation and early organogenesis. 
#' \emph{Nature} 566, 7745:490-495.
#'
#' @export
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom BiocGenerics sizeFactors
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom methods as
WTChimeraData <- function(type=c("processed", "raw"), samples=NULL, Csparse.assays=TRUE) {
    type <- match.arg(type)
    versions <- list(base="1.0.0")
    .getRNAseqData("wt-chimera", type, versions, samples, sample.options=as.character(seq_len(10)), sample.err="1:10", makeCsparse=Csparse.assays)
}
