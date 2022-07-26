#' Sample metadata from the Argelaguet et al. multiome atlas
#'
#' A data frame containing stage and genotype information for
#' the multiome atlas dataset.
#'
#' @format A data frame containing information for each 10x sample
#' of the embryo atlas.
#' This object contains:
#' \describe{
#' \item{\code{sample}:}{Integer, 10x sample index.}
#' \item{\code{sample_name}:}{Character, sample name provided by authors.}
#' \item{\code{stage}:}{Character, developmental stage from which sample was generated.}
#' \item{\code{ncells}:}{Integer, number of cells (post-QC) per sample.}
#' \item{\code{genotype}:}{Character, T_KO if brachyury knockout sample, otherwise WT.}
#' }
#'
#' @examples head(RASampleMetadata)
#'
#' @references
#' Pijuan-Sala B, Griffiths JA, Guibentif C et al. (2019).
#' A single-cell molecular map of mouse gastrulation and early organogenesis.
#' \emph{Nature} 566, 7745:490-495.
#'
#' @export
RASampleMetadata <- read.table(
    text = 
        "sample,sample_name,stage,ncells,genotype
        1,E7.5_rep1,E7.5,8116,WT
        2,E7.5_rep2,E7.5,8692,WT
        3,E7.75_rep1,E7.75,1962,WT
        4,E8.0_rep1,E8.0,6261,WT
        5,E8.0_rep2,E8.0,5469,WT
        6,E8.5_rep1,E8.5,8795,WT
        7,E8.5_rep2,E8.5,6970,WT
        8,E8.75_rep1,E8.75,3836,WT
        9,E8.75_rep2,E8.75,5202,WT
        10,E8.5_CRISPR_T_KO,E8.5,7148,T_KO
        11,E8.5_CRISPR_T_WT,E8.5,7381,WT",
    header = TRUE,
    sep = ",",
    stringsAsFactors = FALSE)