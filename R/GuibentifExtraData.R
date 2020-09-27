#' Guibentif et al. accessory data
#'
#' Obtain the trajectory and NMP ordering data used in Guibentif et al.
#'
#' @return 
#' A \code{list} of the relevant somitogenesis trajectory and NMP ordering data will be returned.
#' Details of the list structure are described in Details, below.
#' 
#' @details
#' This function downloads the data used in some of the analyses from Guibentif et al. (2020).
#' Specifically, it contains the NMP cell orderings, and the atlas somitogenesis trajectory data.
#' 
#' This data is stored in a list.
#' The first element of the list is named \code{atlas_somite_trajectories}, and is itelf a list that contains:
#' \itemize{
#' \item{\code{masses}:}{A data.frame containing the mass allocated to each cell from each trajectory (note: excluding extraembryonic, mixed_gastrulation timepoint, and doublet or stripped nuclei cells).}
#' \item{\code{membership}:}{A data.frame containing the somite trajectory labels used in the paper, calculated from \code{masses}.}
#' }
#' The second element is named \code{nmp_orderings}, and is also a list, which contains:
#' \itemize{
#' \item{\code{atlas}:}{A data.frame containing the position for each cell in the NMP ordering from the embryo atlas (see \code{\link{EmbryoAtlasData}}).}
#' \item{\code{wt_chimera}:}{A data.frame containing the position for each cell in the NMP ordering from the WT chimera data (see \code{\link{WTChimeraData}}).}
#' \item{\code{t_chimera}:}{A data.frame containing the position for each cell in the NMP ordering from the T chimera data (see \code{\link{TChimeraData}}).}
#' }
#' 
#' @author Jonathan Griffiths
#' @examples
#' data <- GuibentifExtraData()
#'
#' @references
#' Guibentif C, Griffiths JA et al. (2020). 
#' Title. 
#' \emph{Journal} 566, 7745:490-495.
#' 
#' @export
#' @importFrom ExperimentHub ExperimentHub
GuibentifExtraData <- function(){
    hub <- ExperimentHub()
    host <- file.path("MouseGastrulationData", "guibentif-accessory", "1.4.0")
    masses <- hub[hub$rdatapath==file.path(host, "wot_masses.rds")][[1]]
    labels <- hub[hub$rdatapath==file.path(host, "wot_somite_trajectories.rds")][[1]]
    order_names <- c("atlas", "wt-chimera", "t-chimera")
    nmp_orderings <- lapply(order_names, function(x){
        hub[hub$rdatapath==file.path(host, sprintf("nmp_ordering_%s.rds", x))][[1]]
    })
    names(nmp_orderings) <- gsub("-", "_", order_names) #allow easy list access with $
    list(
        atlas_somite_trajectories = list(masses=masses, membership=labels),
        nmp_orderings=nmp_orderings
    )
}