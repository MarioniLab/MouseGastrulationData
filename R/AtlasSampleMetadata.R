#' Sample metadata from the Pijuan-Sala et al. embryo atlas
#'
#' A data frame containing stage and embryo pool information for
#' the atlas dataset.
#'
#' @format A data frame containing information for each 10x sample
#' of the embryo atlas.
#' This object contains:
#' \describe{
#' \item{\code{sample}:}{Integer, 10x sample index.}
#' \item{\code{stage}:}{Character, developmental stage from which sample was generated.}
#' \item{\code{pool_index}:}{Integer, index for pools of embryos; samples with the same values are from the same pool of dissociated cells.}
#' \item{\code{seq_batch}:}{Integer, seqencing batch index; samples with the same values were multiplexed for sequencing.}
#' \item{\code{ncells}:}{Integer, number of cells (post-QC) per sample.}
#' }
#' Note that sample 11 is missing by design due to experimental failure: it is not available for download.
#'
#' @examples head(AtlasSampleMetadata)
#'
#' @references
#' Pijuan-Sala B, Griffiths JA, Guibentif C et al. (2019).
#' A single-cell molecular map of mouse gastrulation and early organogenesis.
#' \emph{Nature} 566, 7745:490-495.
#'
#' @export
AtlasSampleMetadata <- read.table(
    text = 
        "sample,stage,pool_index,seq_batch,ncells
        1,E6.5,1,1,360
        2,E7.5,2,1,356
        3,E7.5,3,1,458
        4,E7.5,4,1,276
        5,E6.5,5,1,1207
        6,E7.5,6,1,2798
        7,E6.75,7,1,2169
        8,E7.75,8,1,3254
        9,E7.75,8,1,3093
        10,E7.0,9,1,2359
        12,E7.75,11,2,5305
        13,E7.75,11,2,6068
        14,E7.0,12,2,1311
        15,E7.0,12,2,1620
        16,E8.0,13,2,6230
        17,E8.5,14,2,4483
        18,E6.5,15,2,2130
        19,E7.5,16,2,6996
        20,E7.5,16,2,1992
        21,mixed_gastrulation,17,2,4651
        22,mixed_gastrulation,17,2,4674
        23,E7.25,18,2,1429
        24,E8.25,19,2,6707
        25,E8.25,19,2,7289
        26,E7.25,20,2,6649
        27,E7.25,20,2,7216
        28,E8.25,21,2,4646
        29,E8.5,22,3,7569
        30,E7.0,23,3,3785
        31,E7.0,23,3,3778
        32,E7.0,23,3,3718
        33,E8.0,24,3,5443
        34,E8.0,24,3,5314
        35,E8.0,24,3,5072
        36,E8.5,25,3,4915
        37,E8.5,26,3,4011",
    header = TRUE,
    sep = ",",
    stringsAsFactors = FALSE)