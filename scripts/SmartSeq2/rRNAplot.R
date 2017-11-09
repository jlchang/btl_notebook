library(tidyverse)

#SSF = commandArgs(trailingOnly=TRUE)

report = list.files( path = "." , pattern = "*.MdReport.tsv")
{
if (length(report)==0) { stop("no report found")}
}
{
if (length(report) > 1) { stop("more than one report found")}
print("reporting on: ")
}
print(report)

report.split <- unlist(strsplit(report, "_"))
SSF <- report.split[1]

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

#create column in data frame to conditionally color bars where genesDetected < 1000
df$fill <- ifelse(df$genesDetected < 1000, "red", "grey")

filename <- paste("/btl/analysis/SSF/dearchive/plots/",SSF,"_rRNAplot.pdf", sep="")

pdf(file=filename, onefile = TRUE)
#pdf(file=filename, onefile = TRUE, paper='USr')



# purple reference: 20% of samples (vert)

rRNA<-ggplot(data=df, aes(x = reorder(sampleName, rRNArate), y=rRNArate, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=0.30, colour ="red") + geom_hline(yintercept=mean(df$rRNArate), colour = "blue") + geom_text(aes(5,signif(mean(df$rRNArate), digits = 3),label = signif(mean(df$rRNArate), digits = 3), vjust = -1)) + scale_fill_identity()

rRNA +  xlab("Sample Name")

dev.off() 

