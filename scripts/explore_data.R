# 1 Load Files and libraries

library(readr)
library(tidyverse)
library(treemap)
library(RColorBrewer)
library(lubridate)
library(xtable)
library(knitr)
library(DT)

# Read the data already takes minutes.
nline=502617
data=read_tsv("data/ukb11334.tab.gz", n_max=nline)

# General features
# 1. Sex  
a=table(data[,1])
cat("ok")

# The column is coded with 0=female and 1=male
t=table(data$f.31.0.0)
a=t[1]
b=t[2]
c=round(a/nrow(data)*100 , 2)
d=round(b/nrow(data)*100 , 2)
cat("women =",a , "(", c, "%) and men =", b , "(",d,'%)')
# In the dataset I have 273453 women (54.41%) and 229163 men (45.59%).

#------------------------------------------------------------------------
# 2.Ethical 
ethni_key=data.frame(
  code=c("1","1001","2001","3001","4001","2","1002","2002","3002","4002","3","1003","2003","3003","4003","4","2004","3004","5","6","-1","-3"),
  value=c("White","British","White and Black Caribbean","Indian","Caribbean","Mixed","Irish","White and Black African","Pakistani","African","Asian or Asian British","Other white background","White and Asian","Bangladeshi","Any other Black background","Black or Black British","Any other mixed background","Any other Asian background","Chinese","Other ethnic group","Do not know","Prefer not to answer")
)
ethni_key

# prepare data
data$f.21000.0.0=as.factor(data$f.21000.0.0)
tmp=as.data.frame(table( data$f.21000.0.0 ))
colnames(tmp)=c("code","freq")
tmp$value=ethni_key$value[ match( tmp$code, ethni_key$code ) ]

# make the treemap
treemap(tmp, index=c("value"), vSize='freq', type="index",
        inflate.labels=T,
        fontface.labels=1,
        fontsize.labels=3,
        sortID = "size",
        title="The ethnical background in UKBioBank data",
        format.legend = list(scientific = FALSE, big.mark = " "))
#------------------------------------------------------------------------
# 3.  Time stamp
# Attend: Let’s show the number of assessment that have been done each 
#week between 2006 and 2010. Apparently, a few first trials have been 
#done on 2006. Then the experiment really started on the 20th week 
#of 2007 and finish on the 30th week of 2010.
# Change the format of this column, it must be a date.
# Change the format of this column, it must be a date.
data$f.53.0.0=as.Date(data$f.53.0.0)

# Change format with lubridate and show the data with ggplot2.
data %>%
  mutate(year=year(f.53.0.0), week=week(f.53.0.0)) %>%
  ggplot( aes(x=week, fill=year)) +
  geom_histogram(col='#515A5A', binwidth=1,colour ='red') +
  facet_wrap(~year, scales = "fixed", nrow=1) +
  ylab("The number of assessment realized each week") +
  theme(
    legend.position="left"
  )

#------------------------------------------------------------------------
#4 all  Diseases
#When someone is sick, its diseases is classified in one of
#the ICD categories. The corresponding code are written in the 
#field f.41202.0.to f.41202.0.379 for the first diagnoses. 
#A second diagnoses can be found and thus writtent in the 
#fields f.41204.0.0 to f.41204.0.434.

nline=502617
dis_data=read_tsv("data/mainSecICD10.tab.gz", n_max=nline)

dis_freq=dis_data %>% 
  select(  f.41202.0.0:f.41202.0.379  ,  f.41204.0.0:f.41204.0.434  ) %>%
  gather(key='column', value='disease') %>%
  na.omit() %>%
  group_by(disease) %>%
  count() %>%
  left_join(ICD, by = c("disease" = "coding_L4"))

# count the occurence of each category
tmp = dis_freq %>%
  group_by(short) %>%
  summarize(tot=sum(n)) %>%
  na.omit()

# basic treemap 
p=treemap(tmp,
          index=c("short"),
          vSize="tot",
          type="index"
)        
Sys.setenv('R_MAX_VSIZE'=64000000000)


