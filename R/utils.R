#' Cell type colours
#'
#' Obtain the vector of cell type colours used in Pijuan-Sala et al. (2019).
#' 
#' @return 
#' A vector of RGB hexcodes, named according to the celltypes present in \code{\link{EmbryoAtlasData}}
#' 
#' @details
#' This vector of colours can be used directly as the \code{values} argument of \code{ggplot2::scale_color_manual}, 
#' or may be accessed using celltype labels for base R plotting.
#' Colours for doublets or stripped nuclei are not included.
#' 
#' @author JonathanGriffiths
#' @examples
#' \dontrun{cols <- CelltypeColours()
#'
#' head(cols)
#' }
#'
#' @references
#' Pijuan-Sala B, Griffiths JA, Guibentif C et al. (2019). 
#' A single-cell molecular map of mouse gastrulation and early organogenesis. 
#' \emph{Nature} 566, 7745:490-495.
CelltypePalette <- function(){
    vec <- c(
        "Epiblast" = "#635547",
        "Primitive Streak" = "#DABE99",
        "Caudal epiblast" = "#9E6762",
        "PGC" = "#FACB12",
        "Anterior Primitive Streak" = "#C19F70",
        "Notochord" = "#0F4A9C",
        "Def. endoderm" = "#F397C0",
        "Gut" = "#EF5A9D",
        "Nascent mesoderm" = "#C594BF",
        "Mixed mesoderm" = "#DFCDE4",
        "Intermediate mesoderm" = "#139992",
        "Caudal Mesoderm" = "#3F84AA",
        "Paraxial mesoderm" = "#8DB5CE",
        "Somitic mesoderm" = "#005579",
        "Pharyngeal mesoderm" = "#C9EBFB",
        "Cardiomyocytes" = "#B51D8D",
        "Allantois" = "#532C8A",
        "ExE mesoderm" = "#8870AD",
        "Mesenchyme" = "#CC7818",
        "Haematoendothelial progenitors" = "#FBBE92",
        "Endothelium" = "#FF891C",
        "Blood progenitors 1" = "#F9DECF",
        "Blood progenitors 2" = "#C9A997",
        "Erythroid1" = "#C72228",
        "Erythroid2" = "#F79083",
        "Erythroid3" = "#EF4E22",
        "NMP" = "#8EC792",
        "Rostral neurectoderm" = "#65A83E",
        "Caudal neurectoderm" = "#354E23",
        "Neural crest" = "#C3C388",
        "Forebrain/Midbrain/Hindbrain" = "#647A4F",
        "Spinal cord" = "#CDE088",
        "Surface ectoderm" = "#F7F79E",
        "Visceral endoderm" = "#F6BFCB",
        "ExE endoderm" = "#7F6874",
        "ExE ectoderm" = "#989898",
        "Parietal endoderm" = "#1A1A1A"
        )
    return(vec)
}
