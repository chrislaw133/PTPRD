library(LAVA)
input = process.input(input.info.file="/path/to/input.info.txt",
                      sample.overlap.file="/path/to/sample.overlap.file", #Optional; NULL
                      ref.prefix="/path/to/g1000_EUR/g1000_eur",
                      phenos= c('F1'))

loci = read.loci("/path/to/locus.txt")
locus = process.locus(loci[1,], input)
run.univ(locus, phenos="F1")