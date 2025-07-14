#GenomicSEM

#Munges sumstats
munge(c("/path/to/MDD.txt", "/path/to/ADHD.txt", "/path/to/BPD.txt"),hm3 = "/path/to/w_hm3.snplist", trait.names = c("MDD", "ADHD", "BPD"), info.filter = 0.9, maf.filter = 0.01) 


#Running multivariate LDSC
traits <- c("/path/to/MDD.sumstats.gz", "/path/to/ADHD.sumstats.gz", "/path/to/BPD.sumstats.txt")
sample.prev <- c(0.20608, 0.20708, 0.07055)
population.prev <- c(0.064, 0.028, 0.018)
ld <- "/path/to/eur_w_ld_chr"
wld <- "/path/to/eur_w_ld_chr/"
trait.names<-c("MDD", "ADHD", "BPD")
LDSCoutput <- ldsc(traits=traits, sample.prev=sample.prev, population.prev=population.prev, ld=ld, wld=wld, trait.names=trait.names)


#Preparing sumstats for multivariate GWAS
files <- list("/path/to/MDD.txt", "/path/to/ADHD.txt", "/path/to/BPD.txt")
ref <- "/path/to/reference/reference.1000G.maf.0.005.txt"
se.logit <- c(T,T,T)
multivariatesumstats <- sumstats(files=files, ref=ref, trait.names=c("MDD", "ADHD", "BPD"), se.logit=se.logit, OLS = NULL, linprob = NULL, N=NULL, info.filter=0.8, maf.filter=0.01, keep.indel=FALSE, parallel=TRUE, cores=1)


#Running multivariate GWAS
covstruc = LDSCoutput
SNPs = multivariatesumstats
model <- "F1 =~ MDD + ADHD + BPD
F1 ~ SNP
MDD~~a*MDD
a > 0.001" #Model constraint to prevent MDD from having a negative residual variance
GWASFINAL <- userGWAS(covstruc=covstruc, SNPs=SNPs, model=model, smooth_check=TRUE, fix_measurement=TRUE, Q_SNP=TRUE, modelchi = TRUE)
fwrite(GWASFINAL, "/path/to/output_dir/mvgwas_raw.txt")
