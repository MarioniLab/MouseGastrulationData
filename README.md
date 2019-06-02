# MouseGastrulationData

## Processed *scRNAseq* timecourse data along mouse gastrulation and early organogenesis

This package contains the processed 10X Genomics data from Pijuan-Sala et al. (2019), which were processed as described in the paper, and at its repository [on Github](https://github.com/MarioniLab/EmbryoTimecourse2018/).
This includes gene counts, cell annotation, and reduced-dimension representations for the atlas, which are stored as a `SingleCellExperiment` object.

## Processed *scRNAseq* data of chimeric embryos

Data for chimeric embryos, also generated for Pijuan-Sala et al. (2019), are available via this package, presented in a similar manner to the atlas data.
These include the *Tal1*<sup>-/-</sup>/wild-type and wild-type/wild-type chimaeras.

## To install


## References

Blanca Pijuan-Sala<sup>\*</sup>, Jonathan A. Griffiths<sup>\*</sup>, Carolina Guibentif<sup>\*</sup>, Tom W. Hiscock, Wajid Jawaid, Fernando J. Calero-Nieto, Carla Mulas, Ximena Ibarra-Soria, Richard C.V. Tyser, Debbie Lee Lian Ho, Wolf Reik, Shankar Srinivas, Benjamin D. Simons, Jennifer Nichols, John C. Marioni, Berthold Göttgens. A single-cell molecular map of mouse gastrulation and early organogenesis. *Nature* __566__, pp490-495 (2019).

## Acknowledgement

Thanks to Aaron Lun, on whose work on the [scRNAseq](https://github.com/drisso/scRNAseq/tree/ehub) package this package is based.
