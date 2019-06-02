#' Tal1 chimera data
#'
#' Obtain the processed or raw counts for the Tal1 chimeric mouse embryo dataset.
#'
#' @param type String specifying the type of data to obtain, see Details.
#' @param raw.samples Integer or character vector specifying the samples for which raw count matrices should be obtained.
#' If \code{NULL}, raw count matrices are returned for all (four) samples.
#'
#' @return 
#' If \code{type="processed"}, a \linkS4class{SingleCellExperiment} is returned containing processed data from all sapmles.
#'
#' If \code{type="raw"}, a \linkS4class{List} of SingleCellExperiments is returned,
#' each containing the raw counts for a single sample.
#' List elements are named after the corresponding sample.
#' 
#' @details
#' This function downloads the data for the Tal1 chimera experiment from Pijuan-Sala et al. (2019).
#' The dataset contains four 10X Genomics samples:
#' \itemize{
#' \item Sample 1: _Tal1_ knock-out cells (tomato positive), batch 1
#' \item Sample 2: _Tal1_ knock-out cells (tomato positive), batch 2
#' \item Sample 3: wild-type cells (tomato negative), batch 1
#' \item Sample 4: wild-type cells (tomato negative), batch 2
#' }
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
#' The raw data contains the unfiltered count matrix for each sample, as generated directly from the CellRanger software.
#' No filtering has been performed to identify cells.
#' This may be useful if performing analyses that need to account for the ambient RNA pool.
#' 
#' For both raw and processed data, the row metadata contains the Ensembl ID and symbol for each gene.
#'
#' @author Aaron Lun
#' @examples
#' \dontrun{tal1.data <- Tal1ChimeraData()
#'
#' tal1.data <- Tal1ChimeraData(type="processed")
#' }
#'
#' @references
#' Pijuan-Sala B, Griffiths JA et al. (2019). 
#' A single-cell molecular map of mouse gastrulation and early organogenesis. 
#' \emph{Nature} 566, 7745:490-495.
#'
#' @export
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom BiocGenerics sizeFactors
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom methods as
Tal1ChimeraData <- function(type=c("processed", "raw"), raw.samples=NULL) {
    type <- match.arg(type)

    host <- file.path("MouseGastrulationData", "tal1-chimera")
    hub <- ExperimentHub()
    rowdata <- hub[hub$rdatapath==file.path(host, "rowdata.rds")][[1]]
    rowdata <- as(rowdata, "DataFrame")

    if (type=="processed") {
        counts <- hub[hub$rdatapath==file.path(host, "counts-processed-all.rds")][[1]]
        coldata <- hub[hub$rdatapath==file.path(host, "coldata.rds")][[1]]
        sf <- hub[hub$rdatapath==file.path(host, "sizefac.rds")][[1]]
        output <- SingleCellExperiment(list(counts=counts), rowdata=rowdata, colData=as(coldata, "DataFrame"))
        sizeFactors(output) <- sf

    } else {
        ALLSAMPLES <- as.character(seq_len(4))
        if (is.null(raw.samples)) {
            raw.samples <- ALLSAMPLES
        }

        raw.samples <- as.character(raw.samples)
        if (!all(raw.samples %in% ALLSAMPLES)) {
            stop("'raw.samples' must be in 1:4")
        }

        output <- List()
        for (i in raw.samples) {
            counts <- hub[hub$rdatapath==file.path(host, sprintf("counts-raw-sample%s.rds", i))][[1]]
            output[[i]] <- SingleCellExperiment(list(counts=counts), rowData=rowdata)
        }
    }

    output
}
