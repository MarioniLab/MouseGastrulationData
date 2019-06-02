#' Mouse gastrulation timecourse data
#'
#' Obtain the processed counts for the mouse gastrulation scRNAseq dataset.
#'
#' @return 
#' A \linkS4class{SingleCellExperiment} is returned containing processed data from all samples.
#'
#' 
#' @details
#' This function downloads the data for the embryo atlas from Pijuan-Sala et al. (2019).
#' The dataset contains 36 10X Genomics samples; sample 11 is absent due to QC failure.
#' 
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
#' For both raw and processed data, the row metadata contains the Ensembl ID and symbol for each gene.
#'
#' @author Aaron Lun, with modification by Jonathan Griffiths
#' @examples
#' \dontrun{atlas.data <- AtlasData()
#'
#' atlas.data <- AtlasData(type="processed")
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
Tal1ChimeraData <- function() {
    type <- match.arg(type)

    host <- file.path("MouseGastrulationData", "atlas")
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
