#' Mouse gastrulation timecourse data
#'
#' Obtain the processed or raw counts for the mouse gastrulation scRNAseq dataset.
#'
#' @param type String specifying the type of data to obtain, see Details.
#' @param raw.samples Integer or character vector specifying the samples for which raw count matrices should be obtained.
#' If \code{NULL}, raw count matrices are returned for all (36) samples.
#' 
#' @return 
#' If \code{type="processed"}, a \linkS4class{SingleCellExperiment} is returned containing processed data from all sapmles.
#'
#' If \code{type="raw"}, a \linkS4class{List} of SingleCellExperiments is returned,
#' each containing the raw counts for a single sample.
#' List elements are named after the corresponding sample.
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
#' \item{\code{sample}:}{Integer, index of the sample from which the cell was taken.}
#' \item{\code{pool}:}{Integer, index of the embryo pool from which the sample derived. Samples with the same value are technical, not biological, replicates}
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
#' The raw data contains the unfiltered count matrix for each sample, as generated directly from the CellRanger software.
#' Swapped molecules have been removed using \code{DropletUtils::swappedDrops}.
#' No filtering has been performed to identify cells.
#' This may be useful if performing analyses that need to account for the ambient RNA pool.
#' 
#' For both raw and processed data, the row metadata contains the Ensembl ID and MGI symbol for each gene.
#'
#' @author Aaron Lun, with modification by Jonathan Griffiths
#' @examples
#' atlas.data <- EmbryoAtlasData()
#'
#' atlas.data <- EmbryoAtlasData(type="processed")
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
EmbryoAtlasData <- function(type=c("processed", "raw"), raw.samples=NULL) {
    type <- match.arg(type)
    host <- file.path("MouseGastrulationData", "atlas", "1.0.0")
    getProcOrRaw(host, type, raw.samples, raw.options=as.character(c(1:10, 12:37)), raw.err="1:10 or 12:37")
}
