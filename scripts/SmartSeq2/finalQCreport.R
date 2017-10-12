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

filename <- paste("../",SSF,"_finalQC.pdf", sep="")
#filename <- paste("/broad/hptmp/jlchang/SSF-",SSF,"_finalQC.pdf", sep="")

pdf(file=filename, onefile = TRUE)
#pdf(file=filename, onefile = TRUE, paper='USr')



# purple reference: 20% of samples (vert)

gD<-ggplot(data=df, aes(x = reorder(sampleName, genesDetected), y=genesDetected, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=mean(df$genesDetected), colour = "blue") + geom_hline(yintercept=1000, colour ="red") + geom_text(aes(5,signif(mean(df$genesDetected), digits = 3),label = signif(mean(df$genesDetected), digits = 3), vjust = -1)) + scale_fill_identity()

gD +  xlab("Sample Name") 

#plot total reads, ordered by totalReads
tR<-ggplot(data=df, aes(x = reorder(sampleName, totalReads), y=totalReads, fill = fill)) + 
  geom_bar(stat="identity") + 
  theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + 
  geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + 
  geom_hline(yintercept=mean(df$totalReads), colour = "blue") + 
  geom_text(aes(5,signif(mean(df$totalReads), digits = 3),
    label = signif(mean(df$totalReads), digits = 3), vjust = -1)) + scale_fill_identity()

tR +  xlab("Sample Name") 

rA<-ggplot(data=df, aes(x = reorder(sampleName, pctPfReadsAligned), y=pctPfReadsAligned, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=0.70, colour ="red") + geom_hline(yintercept=mean(df$pctPfReadsAligned), colour = "blue") + geom_text(aes(5,signif(mean(df$pctPfReadsAligned), digits = 3),label = signif(mean(df$pctPfReadsAligned), digits = 3), vjust = -1)) + scale_fill_identity()

rA +  xlab("Sample Name") 

mis<-ggplot(data=df, aes(x = reorder(sampleName, meanInsertSize), y=meanInsertSize, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_hline(yintercept=200, colour ="red") + geom_hline(yintercept=median(df$meanInsertSize), colour = "blue") + geom_text(aes(5,signif(median(df$meanInsertSize), digits = 3),label = signif(median(df$meanInsertSize), digits = 3), vjust = -1)) + scale_fill_identity()

mis  +  xlab("Sample Name") 


pA<-ggplot(data=df, aes(x = reorder(sampleName, pctAdapter), y=pctAdapter, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=0.15, colour ="red") + geom_hline(yintercept=mean(df$pctAdapter), colour = "blue") + geom_text(aes(5,signif(mean(df$pctAdapter), digits = 3),label = signif(mean(df$pctAdapter), digits = 3), vjust = -1)) + scale_fill_identity()

pA  +  xlab("Sample Name") 

med<-ggplot(data=df, aes(x = reorder(sampleName, medianInsertSize), y=medianInsertSize, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_hline(yintercept=200, colour ="red") + geom_hline(yintercept=median(df$medianInsertSize), colour = "blue") + geom_text(aes(5,signif(median(df$medianInsertSize), digits = 3),label = signif(mean(df$medianInsertSize), digits = 3), vjust = -1)) + scale_fill_identity()

med  +  xlab("Sample Name") 


pD<-ggplot(data=df, aes(x = reorder(sampleName, percentDuplication), y=percentDuplication, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=0.50, colour ="red") + geom_hline(yintercept=mean(df$percentDuplication), colour = "blue") + geom_text(aes(5,signif(mean(df$percentDuplication), digits = 3),label = signif(mean(df$percentDuplication), digits = 3), vjust = -1)) + scale_fill_identity()

pD +  xlab("Sample Name") 

dRM<-ggplot(data=df, aes(x = reorder(sampleName, duplicationRateOfMapped), y=duplicationRateOfMapped, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=0.50, colour ="red") + geom_hline(yintercept=mean(df$duplicationRateOfMapped), colour = "blue") + geom_text(aes(5,signif(mean(df$duplicationRateOfMapped), digits = 3),label = signif(mean(df$duplicationRateOfMapped), digits = 3), vjust = -1)) + scale_fill_identity()

dRM  +  xlab("Sample Name") 

tD<-ggplot(data=df, aes(x = reorder(sampleName, transcriptsDetected), y=transcriptsDetected, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_hline(yintercept=200, colour ="red") + geom_hline(yintercept=mean(df$transcriptsDetected), colour = "blue") + geom_text(aes(5,signif(mean(df$transcriptsDetected), digits = 3),label = signif(mean(df$transcriptsDetected), digits = 3), vjust = -1)) + scale_fill_identity()

tD  +  xlab("Sample Name") 

rRNA<-ggplot(data=df, aes(x = reorder(sampleName, rRNArate), y=rRNArate, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=0.30, colour ="red") + geom_hline(yintercept=mean(df$rRNArate), colour = "blue") + geom_text(aes(5,signif(mean(df$rRNArate), digits = 3),label = signif(mean(df$rRNArate), digits = 3), vjust = -1)) + scale_fill_identity()

rRNA +  xlab("Sample Name")

cP<-ggplot(data=df, aes(x = reorder(sampleName, chimericPairs), y=chimericPairs, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=0.30, colour ="red") + geom_hline(yintercept=mean(df$chimericPairs), colour = "blue") + geom_text(aes(5,signif(mean(df$chimericPairs), digits = 3),label = signif(mean(df$chimericPairs), digits = 3), vjust = -1)) + scale_fill_identity()

cP +  xlab("Sample Name")

aA<-ggplot(data=df, aes(x = reorder(sampleName, alternativeAlignments), y=alternativeAlignments, fill = fill)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(size=5, angle = 90, hjust = 1)) + geom_vline(xintercept=ceiling(nrow(df)*.2), colour = "purple") + geom_hline(yintercept=0.30, colour ="red") + geom_hline(yintercept=mean(df$alternativeAlignments), colour = "blue") + geom_text(aes(5,signif(mean(df$alternativeAlignments), digits = 3),label = signif(mean(df$alternativeAlignments), digits = 3), vjust = -1)) + scale_fill_identity()

aA +  xlab("Sample Name")





#library(gridExtra)
#grid.arrange(gD, tR)
#grid.arrange(rA, mis)
#grid.arrange(pD, dRM)
#grid.arrange(pA, rRNA)

dev.off() 

