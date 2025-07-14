library(data.table)
library(devtools)
require(GenomicSEM)

munge(c("/deac/bio/lackGrp/lawrcm22/TWAS/sumstats/MDD.txt",
  "/deac/bio/lackGrp/lawrcm22/TWAS/sumstats/ADHD.txt",
  "/deac/bio/lackGrp/lawrcm22/TWAS/sumstats/BPD.txt"),
  hm3 = "$WORKDIR/GenomeSEM/snpslist/w_hm3.snplist",
  trait.names = c("MDD", "ADHD", "BPD"),
  info.filter = 0.9,
  maf.filter = 0.01)
