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
#' \item{\code{sequencing.batch}:}{Integer, sequencing run in which sample was multiplexed.}
#' \item{\code{theiler}:}{Character, Theiler stage from which the sample was taken; alternative scheme to \code{stage}.}
#' \item{\code{doub.density}:}{Numeric, output of (a now-oudated run of) \code{scran::doubletCells}, performed on each sample separately.}
#' \item{\code{doublet}:}{Logical, whether a cell was called as a doublet.}
#' \item{\code{cluster}:}{Integer, top-level cluster to which cell was assigned across all samples.}
#' \item{\code{cluster.sub}:}{Integer, cluster to which cell was assigned when clustered within each \code{cluster}.}
#' \item{\code{cluster.stage}:}{Integer, top-level cluster to which cell was assigned within individual timepoints.}
#' \item{\code{cluster.theiler}:}{Integer, top-level cluster to which cell was assigned within individual Theiler stages.}
#' \item{\code{stripped}:}{Logical, whether a cell was called as a cytoplasm-stripped nucleus.}
#' \item{\code{celltype}:}{Character, cell type to which the cell was assigned.}
#' \item{\code{colour}:}{Integer, cell type colour (hex) as in Pijuan-Sala et al. (2019).}
#' \item{\code{umapX}:}{Numeric, x-coordinate of UMAP plot in Pijuan-Sala et al. (2019).}
#' \item{\code{umapY}:}{Numeric, y-coordinate of UMAP plot in Pijuan-Sala et al. (2019).}
#' }
#' 
#' 
#' The row metadata contains the Ensembl ID and symbol for each gene.
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
AtlasData <- function() {
    type <- match.arg(type)

    host <- file.path("MouseGastrulationData", "atlas")
    hub <- ExperimentHub()
    rowdata <- hub[hub$rdatapath==file.path(host, "rowdata.rds")][[1]]
    rowdata <- as(rowdata, "DataFrame")

    counts <- hub[hub$rdatapath==file.path(host, "counts-processed-all.rds")][[1]]
    coldata <- hub[hub$rdatapath==file.path(host, "coldata.rds")][[1]]
    sf <- hub[hub$rdatapath==file.path(host, "sizefac.rds")][[1]]
    reducedDims <- hub[hub$rdatapath==file.path(host, "reduced-dims.rds")][[1]]
    output <- SingleCellExperiment(
        list(counts=counts), 
        rowData=rowdata, 
        colData=as(coldata, "DataFrame"),
        reducedDims=reducedDims
        )
    sizeFactors(output) <- sf

    output
}
