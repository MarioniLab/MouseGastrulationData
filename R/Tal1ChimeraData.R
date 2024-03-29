#' Tal1 chimera data
#'
#' Obtain the processed or raw counts for the Tal1 chimeric mouse embryo dataset.
#'
#' @param type String specifying the type of data to obtain, see Details.
#' Default behaviour is to return processed data.
#' @param samples Integer or character vector specifying the samples for which data (processed or raw) should be obtained.
#' If \code{NULL} (default), data are returned for all (four) samples.
#' @param Csparse.assays Logical indicating whether to convert assay matrices into the column major format that is more performant with contemporary software packages.
#' Default behaviour is to perform the conversion.
#'
#' @return 
#' If \code{type="processed"}, a \linkS4class{SingleCellExperiment} is returned containing processed data from selected samples.
#'
#' If \code{type="raw"}, a \linkS4class{List} of SingleCellExperiments is returned,
#' each containing the raw counts for a single sample.
#' List elements are named after the corresponding sample.
#' 
#' @details
#' This function downloads the data for the E8.5 Tal1 chimera experiment from Pijuan-Sala et al. (2019).
#' The dataset contains four 10X Genomics samples:
#' \itemize{
#' \item Sample 1: _Tal1_ knock-out cells (tomato positive)
#' \item Sample 2: _Tal1_ knock-out cells (tomato positive)
#' \item Sample 3: wild-type cells (tomato negative)
#' \item Sample 4: wild-type cells (tomato negative)
#' }
#' All samples are from E8.5, from the same pool of chimeric embryos.
#' Different samples with the same Tomato status are therefore technical replicates of each other.
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
#' @author Aaron Lun
#' @examples
#' tal1.data <- Tal1ChimeraData(samples = 1)
#'
#' tal1.data <- Tal1ChimeraData(type="processed", samples = 1)
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
Tal1ChimeraData <- function(type=c("processed", "raw"), samples=NULL, Csparse.assays=TRUE) {
    type <- match.arg(type)
    versions <- list(base="1.0.0")
    .getRNAseqData("tal1-chimera", type, versions, samples, sample.options=as.character(seq_len(4)), sample.err="1:4", makeCsparse=Csparse.assays)
}
