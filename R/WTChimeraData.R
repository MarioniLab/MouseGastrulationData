#' WT chimera data
#'
#' Obtain the processed counts for the WT chimeric mouse embryo dataset.
#'
#' @return 
#' A \linkS4class{SingleCellExperiment} is returned containing processed data from all samples.
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
#' \item{\code{stage.mapped}:}{Character, stage of the mouse embryo atlas to which the cell was mapped.}
#' \item{\code{celltype.mapped}:}{Character, cell type of the mouse embryo atlas to which the cell was mapped.}
#' \item{\code{haem_closestcell}:}{???}
#' \item{\code{haem_subcluster}:}{???}
#' }
#' 
#' 
#' The row metadata contains the Ensembl ID and symbol for each gene.
#'
#' @author Aaron Lun, with modification by Jonathan Griffiths
#' @examples
#' \dontrun{wt.data <- WTChimeraData()
#'
#' wt.data <- WTChimeraData(type="processed")
#' }
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
WTChimeraData <- function() {
    type <- match.arg(type)

    host <- file.path("MouseGastrulationData", "wt-chimera")
    hub <- ExperimentHub()
    rowdata <- hub[hub$rdatapath==file.path(host, "rowdata.rds")][[1]]
    rowdata <- as(rowdata, "DataFrame")

    counts <- hub[hub$rdatapath==file.path(host, "counts-processed-all.rds")][[1]]
    coldata <- hub[hub$rdatapath==file.path(host, "coldata.rds")][[1]]
    sf <- hub[hub$rdatapath==file.path(host, "sizefac.rds")][[1]]
    output <- SingleCellExperiment(list(counts=counts), rowdata=rowdata, colData=as(coldata, "DataFrame"))
    sizeFactors(output) <- sf

    output
}
