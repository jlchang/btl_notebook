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

df2 <- df[ , -which(names(df) %in% c("unpairedReads","failedVendorQCCheck","noCovered5Prime", "fivePrimeNorm"))]

result = data.frame(z = rowSums( df2 == 0 ))

print(result)

df2[which(result$z > 0),]

print("zero values ignored for unpairedReads,failedVendorQCCheck,noCovered5Prime,fivePrimeNorm")
print("rows in MdReport with less expected non-zero values - look for zero values in data above")

which(result$z > 0)


#df <- read.table(
#  file = report,
#  sep="\t",
#  header=F,
#  col.names=c("expt","type","specie","date","sampleName", "indexBarcode1", "indexBarcode2", "totalReads", "pctOfMultiplexedReads",
#              "meanReadLength", "pfReads", "pctPfReads", "pfReadsAligned", "pctPfReadsAligned",
#              "readsAlignedInPairs", "pctReadsAlignedInPairs", "pctAdapter", "r1MeanQual", "r2MeanQual", "pairOrientation", "meanInsertSize", "medianInsertSize", "standardDeviation", "meanGcContent", "percentDuplication", "totalErccReads", "fractionErccReads", "fractionGenomeReferenceReads", "totalUnalignedReads", "fractionUnalignedReads", "fragmentLengthMean", "chimericPairs",
# "readLength", "estimatedLibrarySize", "fragmentLengthStdDev", "expressionProfilingEfficiency", "unpairedReads", "baseMismatchRate", "transcriptsDetected", "totalPurityFilteredReadsSequenced", "failedVendorQCCheck", "meanPerBaseCov", "meanCV", "mapped",
#"mappedPairs", "alternativeAlignments", "uniqueRateofMapped", "mappingRate", "mappedUnique", "end1MappingRate", "end2MappingRate", "mappedUniqueRateofTotal", "duplicationRateOfMapped", "cumulGapLength", "gapPct", "numGaps", "intronicRate", "rRNA", "genesDetected", "rRNArate", "exonicRate", "intragenicRate", "intergenicRate", "end1PctSense", "end1Antisense", "noCovered5Prime", "end2MismatchRate", "end2Antisense", "end2PctSense", "end2Sense", "end1MismatchRate", "end1Sense", "fivePrimeNorm", "Notes"),
#  stringsAsFactors = TRUE
#)

#df <- read.table(
#  file = report,
#  sep="\t",
#  header=T,
#  col.names=c("sampleName", "indexBarcode1", "indexBarcode2", "totalReads", "pctOfMultiplexedReads",
#              "meanReadLength", "pfReads", "pctPfReads", "pfReadsAligned", "pctPfReadsAligned",
#              "readsAlignedInPairs", "pctReadsAlignedInPairs", "pctAdapter", "r1MeanQual", "r2MeanQual", "pairOrientation", "meanInsertSize", "medianInsertSize", "standardDeviation", "meanGcContent", "percentDuplication", "totalErccReads", "fractionErccReads", "fractionGenomeReferenceReads", "totalUnalignedReads", "fractionUnalignedReads", "fragmentLengthMean", "chimericPairs", "readLength", "estimatedLibrarySize", "fragmentLengthStdDev", "expressionProfilingEfficiency", "unpairedReads", "baseMismatchRate", "transcriptsDetected", "totalPurityFilteredReadsSequenced", "failedVendorQCCheck", "meanPerBaseCov", "meanCV", "mapped", "mappedPairs", "alternativeAlignments", "uniqueRateofMapped", "mappingRate", "mappedUnique", "end1MappingRate", "end2MappingRate", "mappedUniqueRateofTotal", "duplicationRateOfMapped", "cumulGapLength", "gapPct", "numGaps", "intronicRate", "rRNA", "genesDetected", "rRNArate", "exonicRate", "intragenicRate", "intergenicRate", "end1PctSense", "end1Antisense", "noCovered5Prime", "end2MismatchRate", "end2Antisense", "end2PctSense", "end2Sense", "end1MismatchRate", "end1Sense", "fivePrimeNorm", "Notes"),
#  stringsAsFactors = FALSE
#)
