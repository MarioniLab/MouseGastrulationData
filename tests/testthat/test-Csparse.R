# This tests the conversion from triplet to column major matrix styles.
# library(testthat); library(MouseGastrulationData); source("test-Csparse.R")

test_that("EmbryoAtlasData function for sample 1, with and without csparse conversion, gives equal counts assay", {
    data_without_csparse <- EmbryoAtlasData(samples = 1, Csparse.assays = FALSE)
    data_with_csparse <- EmbryoAtlasData(samples = 1, Csparse.assays = TRUE)
    
    expect_equal(assay(data_without_csparse, "counts"),
        as(assay(data_with_csparse, "counts"), "TsparseMatrix"))
})
