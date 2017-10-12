report <- Sys.glob("*.MdReport.tsv")

if (length(report) > 1) {
print(report)
stop("more than one report found")
parent.frame(3)$exit.source(7)  # exit script 
}

df <- read.table(
  file = report,
  sep="\t",
  header=T,
  stringsAsFactors = FALSE
)


