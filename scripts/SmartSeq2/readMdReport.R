library(tidyverse)

#report = commandArgs(trailingOnly=TRUE)

report = list.files( path = "." , pattern = "*.MdReport.tsv")
{
if (length(report)==0) { stop("no report found")}
}
{
if (length(report) > 1) { stop("more than one report found")}
print("reporting on: ")
}
print(report)

# test if there is at least one argument: if not, use test file
#if (length(report)==0) {
#	report = "/btl/projects/SSF/SmartSeq2/MdReports/SSF-11663_SmartSeqAnalysisV1.1_1.1500394646935.MdReport.tsv"
#}

df <- read.table(
  file = report,
  sep="\t",
  header=T,
  stringsAsFactors = FALSE
)


