#!/bin/R

website = "https://content.cruk.cam.ac.uk/jmlab/chimera_t_data/accessory"

wot_masses = read.table(
    file.path(website, "atlas_WOT_masses.tsv"),
    sep = "\t",
    header = TRUE
)
#correct names to match metadata
names(wot_masses) = gsub(".", " ", names(wot_masses), fixed = TRUE)
names(wot_masses) = gsub(" most", "-most", names(wot_masses))
names(wot_masses)[names(wot_masses) == "Def  endoderm"] = "Def. endoderm"
names(wot_masses)[names(wot_masses) == "Forebrain Midbrain Hindbrain"] = "Forebrain/Midbrain/Hindbrain"

wot_membership = read.table(
    file.path(website, "atlas_WOT_trajectory_membership.tsv"),
    sep = "\t",
    header = FALSE
)
names(wot_membership) = c("cell", "somite_trajectory")

nmp_ordering = lapply(c("atlas", "t-chimera", "wt-chimera"), function(x){
    tab = read.table(
        file.path(website, "nmp_ordering", paste0(x, ".tsv")),
        sep = "\t",
        header = FALSE
    )
    names(tab) = c("cell", "position")
    return(tab)
})
names(nmp_ordering) = c("atlas", "t-chimera", "wt-chimera")

base <- file.path("MouseGastrulationData", "guibentif-accessory", "1.4.0")
dir.create(base, recursive=TRUE, showWarnings=FALSE)
saveRDS(wot_masses, file = file.path(base, "wot_masses.rds"))
saveRDS(wot_membership, file = file.path(base, "wot_somite_trajectories.rds"))
for(i in seq_along(nmp_ordering)){
    saveRDS(
        nmp_ordering[[i]], 
        file = file.path(base, paste0("nmp_ordering_", names(nmp_ordering)[i], ".rds"))
    )
}

## Make metadata
info <- data.frame(
    Title = sprintf("%s used in Guibentif et al. 2020", 
        c("WOT masses",
            "Somitogenesis trajectory membership",
            "Embryo atlas NMP cell ordering",
            "T chimera atlas NMP cell ordering",
            "WT chimera atlas NMP cell ordering")
    ),
    Description = sprintf("%s used in Guibentif et al. 2020", 
        c("Per-cell masses calculated using the Waddington Optimal Transport tool",
            "Per-cell trajectory annotations derived from the WOT masses",
            "Ordering of cells from embryo atlas data in the NMP ordering",
            "Projected location of cells from T chimera data in the NMP ordering",
            "Projected location of cells from WT chimera data in the NMP ordering")
    ),
    RDataPath = file.path(
        base, 
        c("wot_masses.rds",
            "wot_somite_trajectories.rds",
            sprintf("nmp_ordering_%s.rds", names(nmp_ordering)))
    ),
    BiocVersion="3.12",
    Genome="mm10",
    SourceType="TXT",
    SourceUrl=c(
        rep(website, 2),
        rep(file.path(website, "nmp_ordering"), 3)
    ),
    SourceVersion=c(
        "atlas_WOT_masses.tsv",
        "atlas_WOT_trajectory_membership.tsv",
        sprintf("nmp_ordering_%s.tsv", names(nmp_ordering))
    ),
    Species="Mus musculus",
    TaxonomyId="10090",
    Coordinate_1_based=TRUE,
    DataProvider="Jonathan Griffiths",
    Maintainer="Jonathan Griffiths <jonathan.griffiths.94@gmail.com>",
    RDataClass="character",
    DispatchClass="Rds",
    stringsAsFactors = FALSE
)

write.csv(file="../../extdata/metadata-guibentif-accessory.csv", info, row.names=FALSE)