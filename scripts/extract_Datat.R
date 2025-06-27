library(RISmed)
library('bibliometrix')

#"2014/01/01"[PDAT]:"2019/9/31"[PDAT] AND (disease comorbidities) AND (mental) AND (diseases) 

search_topic <- 'mental comorbidities'
search_query <- EUtilsSummary(search_topic, retmax=2000, mindate=2014, maxdate=2019)
summary(search_query)
D <- EUtilsGet(search_query)

M <- pubmed2df(D)
#install.packages("bibliometrix")
typeof(M)
write.table(M,"comorbidities_pubmed.txt",sep="\t")

capture.output(summary(M), file = "comorbidities_pubmed.txt")
sink("comorbidities_pubmed.txt")
print(M)
sink()
