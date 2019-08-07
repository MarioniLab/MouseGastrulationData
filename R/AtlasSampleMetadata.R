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
AtlasSampleMetadata <- do.call(rbind, list(
    data.frame(sample=1, stage='E6.5', pool_index=1, seq_batch=1, ncells=360, stringsAsFactors = FALSE),
    data.frame(sample=2, stage='E7.5', pool_index=2, seq_batch=1, ncells=356, stringsAsFactors = FALSE),
    data.frame(sample=3, stage='E7.5', pool_index=3, seq_batch=1, ncells=458, stringsAsFactors = FALSE),
    data.frame(sample=4, stage='E7.5', pool_index=4, seq_batch=1, ncells=276, stringsAsFactors = FALSE),
    data.frame(sample=5, stage='E6.5', pool_index=5, seq_batch=1, ncells=1207, stringsAsFactors = FALSE),
    data.frame(sample=6, stage='E7.5', pool_index=6, seq_batch=1, ncells=2798, stringsAsFactors = FALSE),
    data.frame(sample=7, stage='E6.75', pool_index=7, seq_batch=1, ncells=2169, stringsAsFactors = FALSE),
    data.frame(sample=8, stage='E7.75', pool_index=8, seq_batch=1, ncells=3254, stringsAsFactors = FALSE),
    data.frame(sample=9, stage='E7.75', pool_index=8, seq_batch=1, ncells=3093, stringsAsFactors = FALSE),
    data.frame(sample=10, stage='E7.0', pool_index=9, seq_batch=1, ncells=2359, stringsAsFactors = FALSE),
    data.frame(sample=12, stage='E7.75', pool_index=11, seq_batch=2, ncells=5305, stringsAsFactors = FALSE),
    data.frame(sample=13, stage='E7.75', pool_index=11, seq_batch=2, ncells=6068, stringsAsFactors = FALSE),
    data.frame(sample=14, stage='E7.0', pool_index=12, seq_batch=2, ncells=1311, stringsAsFactors = FALSE),
    data.frame(sample=15, stage='E7.0', pool_index=12, seq_batch=2, ncells=1620, stringsAsFactors = FALSE),
    data.frame(sample=16, stage='E8.0', pool_index=13, seq_batch=2, ncells=6230, stringsAsFactors = FALSE),
    data.frame(sample=17, stage='E8.5', pool_index=14, seq_batch=2, ncells=4483, stringsAsFactors = FALSE),
    data.frame(sample=18, stage='E6.5', pool_index=15, seq_batch=2, ncells=2130, stringsAsFactors = FALSE),
    data.frame(sample=19, stage='E7.5', pool_index=16, seq_batch=2, ncells=6996, stringsAsFactors = FALSE),
    data.frame(sample=20, stage='E7.5', pool_index=16, seq_batch=2, ncells=1992, stringsAsFactors = FALSE),
    data.frame(sample=21, stage='mixed_gastrulation', pool_index=17, seq_batch=2, ncells=4651, stringsAsFactors = FALSE),
    data.frame(sample=22, stage='mixed_gastrulation', pool_index=17, seq_batch=2, ncells=4674, stringsAsFactors = FALSE),
    data.frame(sample=23, stage='E7.25', pool_index=18, seq_batch=2, ncells=1429, stringsAsFactors = FALSE),
    data.frame(sample=24, stage='E8.25', pool_index=19, seq_batch=2, ncells=6707, stringsAsFactors = FALSE),
    data.frame(sample=25, stage='E8.25', pool_index=19, seq_batch=2, ncells=7289, stringsAsFactors = FALSE),
    data.frame(sample=26, stage='E7.25', pool_index=20, seq_batch=2, ncells=6649, stringsAsFactors = FALSE),
    data.frame(sample=27, stage='E7.25', pool_index=20, seq_batch=2, ncells=7216, stringsAsFactors = FALSE),
    data.frame(sample=28, stage='E8.25', pool_index=21, seq_batch=2, ncells=4646, stringsAsFactors = FALSE),
    data.frame(sample=29, stage='E8.5', pool_index=22, seq_batch=3, ncells=7569, stringsAsFactors = FALSE),
    data.frame(sample=30, stage='E7.0', pool_index=23, seq_batch=3, ncells=3785, stringsAsFactors = FALSE),
    data.frame(sample=31, stage='E7.0', pool_index=23, seq_batch=3, ncells=3778, stringsAsFactors = FALSE),
    data.frame(sample=32, stage='E7.0', pool_index=23, seq_batch=3, ncells=3718, stringsAsFactors = FALSE),
    data.frame(sample=33, stage='E8.0', pool_index=24, seq_batch=3, ncells=5443, stringsAsFactors = FALSE),
    data.frame(sample=34, stage='E8.0', pool_index=24, seq_batch=3, ncells=5314, stringsAsFactors = FALSE),
    data.frame(sample=35, stage='E8.0', pool_index=24, seq_batch=3, ncells=5072, stringsAsFactors = FALSE),
    data.frame(sample=36, stage='E8.5', pool_index=25, seq_batch=3, ncells=4915, stringsAsFactors = FALSE),
    data.frame(sample=37, stage='E8.5', pool_index=26, seq_batch=3, ncells=4011, stringsAsFactors = FALSE)
))
