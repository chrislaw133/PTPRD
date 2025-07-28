library(data.table)
library(devtools)
require(GenomicSEM)

munge(c("/path/to/MDD.txt",
  "/path/to/ADHD.txt",
  "/path/to/BPD.txt"),
  hm3 = "/path/to/w_hm3.snplist",
  trait.names = c("MDD", "ADHD", "BPD"),
  info.filter = 0.9,
  maf.filter = 0.01)

#Returns munged summary statistics for multivariable LDSC
