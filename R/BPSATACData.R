#' E8.25 snATAC-seq data
#'
#' Obtain the processed or raw counts for the Pijuan-Sala et al. (2020) E8.25 single-nucleus ATAC-seq dataset.
#'
#' @param type String specifying the type of data to obtain, see Details.
#' Default behaviour is to return processed data.
#' 
#' @return 
#' If \code{type="processed"}, a \linkS4class{SingleCellExperiment} is returned containing the processed data.
#'
#' If \code{type="raw"}, a \linkS4class{SingleCellExperiment} is returned containing the raw data.
#' 
#' @details
#' This function downloads the data for the E8.25 single-nucleus ATAC-seq data from Pijuan-Sala et al. (2020).
#' The dataset is provided as a single sample.
#' 
#' In the processed data, QC-passing libraries have already been identified in each sample.
#' The count matrix contains the number of counts for each identified peak for each cell.
#' Note that you may want to binarise this matrix for downstream analyses.
#' Full details of the methods used in analyses can be found in the paper (see References, below).
#' 
#' The column metadata for cells contains:
#' \describe{
#' \item{\code{sample}:}{Integer, sample index (for consistency across MGD datasets).}
#' \item{\code{stage}:}{Character, collection timepoint (for consistency across MGD datasets).}
#' \item{\code{barcode}:}{Character, unique cell identifier.}
#' \item{\code{nuclei_type}:}{Character, whether cells were selected using flow gates. Note that these are probably not doublets, but cells in different cell cycle phases.}
#' \item{\code{num_of_reads}:}{Integer, number of reads.}
#' \item{\code{promoter_coverage}:}{Numeric, fraction of promoters accessible "in the majority of datasets based on ENCODE DNase Hypersensitive Sites and ATAC-seq data".}
#' \item{\code{read_in_promoter}:}{Integer, number of reads in promoters.}
#' \item{\code{doublet_scores}:}{Numeric, doublet scores (calculated with scrublet v0.4).}
#' \item{\code{read_in_peak}:}{Integer, Number of reads in across-cell-calculated peaks.}
#' \item{\code{ratio_peaks}:}{Numeric, fraction of reads in across-cell peaks.}
#' \item{\code{final_clusters}:}{Integer, final cluster indices.}
#' \item{\code{celltype}:}{Character, celltype label.}
#' \item{\code{al_haem_endo_clusters}:}{Character, clusters from the focused blood, allantois, endothelium celltypes (or NA, for other celltypes).}
#' }
#' Reduced dimension representations of the data are also available in the \code{reducedDims} slot of the SingleCellExperiment object.
#' These are \code{topics} and \code{umap}.
#' Please see the methods of the manuscript (see References, below) for more details on the topic modelling approach.
#' 
#' For both raw and processed data, the row metadata is relatively complex.
#' It contains:
#' \describe{
#' \item{\code{peakID}:}{Character, unique peak identifier.}
#' \item{\code{peak_chr}:}{Character, chromosome ID for each peak.}
#' \item{\code{peak_start}:}{Integer, start position for each peak. As this is from a bed file (I think), this is 0-indexed, and the peak is inclusive of this position.}
#' \item{\code{peak_end}:}{Integer, end position for each peak. As this is from a bed file (I think), this is 0-indexed, and the peak is exclusive of this position.}
#' \item{\code{Annotation.General}:}{Character, general peak annotation (TSS (−1kb to +100 bp), TTS (−100 bp to +1 kb), intron, exon, intergenic).}
#' \item{\code{distance_from_TSS}:}{Integer, distance from the TSS that peaks been annotated to if the region is intergenic. Note: the authors have annotated peaks to multiple genes; distances for different genes are comma-separated in this column.}
#' \item{\code{geneName}:}{Character, gene name (MGI). Note: the authors have annotated peaks to multiple genes; names for different genes are comma-separated in this column.}
#' \item{\code{geneID}:}{Character, gene ID (Ensembl gene ID, v92). Note: the authors have annotated peaks to multiple genes; IDs for different genes are comma-separated in this column.}
#' \item{\code{strand}:}{Character, strand for linked genes. Note: the authors have annotated peaks to multiple genes; strands for different genes are comma-separated in this column.}
#' \item{\code{celltype_specificity}:}{Character, celltype specificity of the peak. For multiple celltypes, authors have semicolon-separated celltype names.}
#' \item{\code{topic}:}{Character, topic membership of the peak. For multiple topics, authors have semicolon-separated topic names.}
#' \item{\code{topic_stringent}:}{Character, topic membership of the peak if it contributes to only a single topic; else "Nonspecific".}
#' \item{\code{accessibility}:}{Integer, number of nuclei with where peak is accessible.}
#' \item{\code{accessibility_log}:}{Numeric, log-transformed number of nuclei with where peak is accessible (base e, with +1).}
#' \item{\code{accessibility_ratio}:}{Numeric, fraction of nuclei where peak is accessible.}
#' \item{\code{umap_X}:}{Numeric, umap x-coordinate of peak.}
#' \item{\code{umap_Y}:}{Numeric, umap y-coordinate of peak.}
#' \item{\code{Pattern_endothelium}:}{Integer, index for dynamic pattern during endothelial establishment (else NA).}
#' }
#' 
#' @author Aaron Lun, with modification by Jonathan Griffiths
#' @examples
#' atac.data <- BPSATACData()
#'
#' atac.data <- BPSATACData(type="processed")
#'
#' @references
#' Pijuan-Sala B et al. (2020). 
#' Single-cell chromatin accessibility maps reveal regulatory programs driving early mouse organogenesis.
#' \emph{Nature Cell Biology} 22, 4:487–97.
#' 
#' @export
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom SingleCellExperiment SingleCellExperiment 
#' @importFrom BiocGenerics sizeFactors
#' @importClassesFrom S4Vectors DataFrame
#' @importFrom methods as
BPSATACData <- function(type=c("processed", "raw")) {
    type <- match.arg(type)
    versions <- list(base="1.6.0")
    .getProcOrRaw("BPS_atac", type, versions, samples=1, sample.options=as.character(1), sample.err="1")
}
