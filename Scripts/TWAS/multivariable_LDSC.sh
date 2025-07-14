require(GenomicSEM)
library(data.table)
library(devtools)

ld <- "/path/to/eur_w_ld_chr/"
wld <- "/path/to/eur_w_ld_chr/"
traits <- c("/path/to/ADHD.sumstats.gz", "/path/to/BPD.sumstats.gz", "/path/to/MDD.sumstats.gz" )
sample.prev <- c(0.20708, 0.07055, 0.20608)
population.prev <- c(0.028, 0.018, 0.064)
trait.names<-c("ADHD", "BPD", "MDD")
gfactor_LDSCoutput <- ldsc(traits, sample.prev, population.prev, ld, wld,trait.names=trait.names)

##optional command to save the ldsc output in case you want to use it in a later R session. 
save(gfactor_LDSCoutput, file="/path/to/gfactor_LDSC.RData")
