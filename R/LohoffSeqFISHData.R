LohoffSeqFISHData <- function(type=c("actual", "imputed"), samples=NULL, get.molecules=FALSE) {
    type <- match.arg(type)
    versions <- list(base="1.6.0")
    extra_a <- NULL
    if(get.molecules){
        if(type=="imputed"){
            stop("Cannot get molecule position data with the imputed data")
        }
        extra_a <- list("molecules" = "molecules-processed")
    }
    .getSeqFISHData("lohoff_seqfish_biorxiv", type, versions, samples, sample.options=as.character(c(1:6)), sample.err="1:6", extra_assays=extra_a)
}
