library(data.table)
library(R.matlab)

mvgwas <- fread('/path/to/sumstats')

# 3) make sure vars_qc SNP ids are in the same order you’ll as the SNP correlation matrix
extract_rs <- scan("/path/to/vars_qc.txt", 
                   what = character())
snps9 <- mvgwas[match(extract_rs, mvgwas$SNP), ]

# 4) pull out the z vector
z <- snps9$Z
#    (or if you only have beta & se: z <- snps9$beta / snps9$se)

# 5) write to MATLAB .mat
if (!requireNamespace("R.matlab", quietly=TRUE))
  install.packages("R.matlab")

R.matlab::writeMat("/path/to/output_dir/glmt.mat", glmt = z)
