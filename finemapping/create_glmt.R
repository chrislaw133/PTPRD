#————— 0) Load required packages —————
library(data.table)
library(R.matlab)

#————— 1) Define file paths —————
zs_path    <- "/path/to/unphased.vcor1.zst" #SNP correlation matrix
vars_path  <- "/path/to/unphased.vcor1.vars" #SNP correlation matrix SNP ids
out_dir    <- "/path/to/out_dir"
mvgwas_path <- "/path/to/sumstats"  # adjust as needed

#————— 2) Read in GWAS summary‐stats table —————
mvgwas <- fread(mvgwas_path)    # assumes column named "SNP"

#————— 3) Read and filter the SNP list by GWAS hits —————
vars_all <- readLines(vars_path)
vars     <- intersect(vars_all, mvgwas$SNP)
message("Keeping ", length(vars), " SNPs present in both LD data and GWAS.")

#————— 4) Load and subset the LD correlation matrix —————
Rmat_full <- as.matrix(
  fread(cmd = sprintf("zstdcat %s", zs_path),
        header = FALSE,
        data.table = FALSE)
)
stopifnot(nrow(Rmat_full) == length(vars_all),
          ncol(Rmat_full) == length(vars_all))

# assign row/col names and then restrict to `vars`
rownames(Rmat_full) <- colnames(Rmat_full) <- vars_all
Rmat <- Rmat_full[vars, vars]
rm(Rmat_full, vars_all)

#————— 5) Subset your GWAS table directly for the SNPs you care about —————
gwas_sub <- mvgwas[ SNP %in% vars, .(SNP, MAF, N) ]
# reorder to match 'vars' exactly
gwas_sub <- gwas_sub[ match(vars, gwas_sub$SNP) ]
stopifnot(all(vars == gwas_sub$SNP))

#————— 6) Extract MAF and verify a single sample size —————
maf <- gwas_sub$MAF
N   <- unique(gwas_sub$N)
if (length(N) != 1) {
  stop("Expected a single N; found: ", paste(N, collapse = ", "))
}


#————— 7) Build the weighted LD matrix A —————
H <- 2 * maf * (1 - maf)    # heterozygosity per SNP
w <- sqrt(N * H)            # weight vector
A <- t(t(Rmat) * w)         # A_{ij} = w_i * R_{ji}

#————— 8) QC step 1: MAF filter (0.05 ≤ MAF ≤ 0.95) —————
maf_thr  <- 0.01
keep_maf <- which(maf >= maf_thr & maf <= 1 - maf_thr)
vars_maf <- vars[keep_maf]
A_maf    <- A[keep_maf, keep_maf]
Rmat_maf <- Rmat[keep_maf, keep_maf]

#————— 9) QC step 2: LD pruning at |r| > 1 —————
corr_thr <- 1
M2       <- length(vars_maf)
keep_ld  <- rep(TRUE, M2)

for (i in seq_len(M2)) {
  if (!keep_ld[i]) next
  high_ld <- which(abs(Rmat_maf[i, ]) > corr_thr)
  keep_ld[ setdiff(high_ld, i) ] <- FALSE
}

kept.vars <- vars_maf[keep_ld]
A_qc      <- A_maf[keep_ld, keep_ld]
Rmat_qc   <- Rmat_maf[keep_ld, keep_ld]


#—————11) Write outputs —————
# Weighted LD matrix for Finemap‐MiXeR
writeMat(file.path(out_dir, "a.mat"), a = A_qc)

# (Optional) If you have a filtered glmt vector:
# writeMat(file.path(out_dir, "glmt.mat"), glmt = glmt_qc)

# QC’d SNP list
writeLines(kept.vars, file.path(out_dir, "vars_qc.txt"))
