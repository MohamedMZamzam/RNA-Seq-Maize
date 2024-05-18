#Set working directory#
setwd("C:/Rawdata (1)/SAM maize/")
#Load libraries#
library(Rsubread)
library (tidyverse)
library(Rsamtools)
library (ShortRead)
library (Rfastp)


#To run QC with Rfastp, we just need to use the rfastp() function on our FASTQ file. 
#We also need to provide the prefix we want for the outputs to outputFastq.

json_report <- rfastp("SRR1620944.fastq.gz", outputFastq = "SRR1620944.fastq_R1" )

qcSummary(json_report)

#generate ref genome
buildindex("ZM_mainchrs", "C:/Rawdata (1)/SAM maize/Genome/Zea_mays.Zm-B73-REFERENCE-NAM-5.0.dna.toplevel.fa.gz", memory = 8000,
           indexSplit = TRUE)

Transcript <- readGFF("Zea_mays.Zm-B73-REFERENCE-NAM-5.0.57.chr.gff3.gz") %>% as.data.frame

SAF <- data.frame(GeneID = Transcript$gene_id, Chr = Transcript$seqid, Start = Transcript$start,
                  End = Transcript$end, Strand = Transcript$strand)



MyMapped <- subjunc("ZM_mainchrs_rap", readfile1 = "SRR1620944.fastq_R1_R1.fastq.gz", output_format = "BAM",
                    output_file = "SRR1620944.bam", useAnnotation = TRUE, annot.ext = SAF, isGTF = FALSE)

sortBam("SRR1620944.bam", "Sorted_SRR1620944")
indexBam("Sorted_SRR1620944.bam")

