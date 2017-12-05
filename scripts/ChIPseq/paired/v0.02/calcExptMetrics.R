######################
#
#  calcExptMetrics.R
#
#  finds simple metrics report in current directory, performs calculations,
#    and generates exptMetrics report
#
######################

library(tidyverse)

#report = commandArgs(trailingOnly=TRUE)

report = list.files( path = "." , pattern = "*.metrics$")
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

df2 <- df %>%
	mutate(
	pct_PE_Tot = PE_Reads/Tot_Reads,
	pct_mapq28PE_Tot = MAPQ_Reads/Tot_Reads,
	loss2mapq28= pct_PE_Tot - pct_mapq28PE_Tot,
	PE_FRIP_calc = PE_rip/PE_Reads,
	mapq28PE_FRIP_calc = mapqPE_rip/MAPQ_Reads,
	aquas_FRIP_calc = aquas_rip/aquas_Reads,
	pct_aquas_Tot = aquas_Reads/Tot_Reads,
	pct_mapq0_Tot = mapq0_Reads/Tot_Reads,
	pct_mapq5cum_Tot = mapq5_Reads/Tot_Reads,
	pct_mapq28cum_Tot = mapq28_Reads/Tot_Reads,
	pct_mapq29cum_Tot = mapq29_Reads/Tot_Reads,
	mapq29only_Reads = mapq29_Reads - mapq28_Reads,
	pct_mapq29only_Tot = mapq29only_Reads/Tot_Reads,
	unmap_Reads = Tot_Reads - MapRaw_Reads,
	pct_unmap_Tot = unmap_Reads/Tot_Reads,
	impropPr_Reads = PrInSeq_Reads - PropPr_Reads,
	pct_impropPr_Tot = impropPr_Reads/Tot_Reads,
	pct_alldup_Tot = allDup_Reads/Tot_Reads,
	pdup_Reads = Tot_Reads - PE_Reads - impropPr_Reads,
	imprdup_Reads = allDup_Reads - pdup_Reads ,
	pct_imprdup_alldup = imprdup_Reads/allDup_Reads,
	imprmp_Reads = impropPr_Reads - unmap_Reads - PrSing_Reads
	) %>%
	
	select(Expt, Sample, 
Tot_Reads, PE_Reads, pct_PE_Tot, 
PE_rip, PE_FRIP_calc,

CASM_R1_TOT,R1_ADAPTER,R1_CHIMERAS,
CASM_R2_TOT,R2_ADAPTER,R2_CHIMERAS,
ELC_PAIRS, pDUPLICATION, EstLibSize,

PrInSeq_Reads, 
impropPr_Reads, pct_impropPr_Tot,
MapRaw_Reads,unmap_Reads, pct_unmap_Tot,
PrSing_Reads, imprdup_Reads,
allDup_Reads, pct_alldup_Tot,
pdup_Reads, pct_imprdup_alldup,
PropPr_Reads, imprmp_Reads, mmdc_Reads,

mapq0_Reads, pct_mapq0_Tot,
mapq29only_Reads, pct_mapq29only_Tot,mapq5_Reads, pct_mapq5cum_Tot, mapq10_Reads, 
mapq28_Reads,pct_mapq28cum_Tot,

loss2mapq28PE = loss2mapq28,
MAPQ28PE_Reads = MAPQ_Reads, pct_mapq28PE_Tot,
mapq28PE_rip = mapqPE_rip,mapq28PE_FRIP_calc,

aquas_Reads, pct_aquas_Tot,
aquas_rip, aquas_FRIP_calc,
mapq29_Reads,pct_mapq29cum_Tot
	)

outfile<-paste0("calculatedMetrics",".txt")
write.table(df2, file=outfile, row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")


