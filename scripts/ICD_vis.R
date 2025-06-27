library(tidyverse)
library(rmarkdown)    # You need this library to run this template.
library(epuRate)      # Install with devtools: install_github("holtzy/epuRate", force=TRUE)
library(DT)           # To display tables
library(RColorBrewer)


# Treemap
library(treemap)            # For the static version
library(d3treeR)            # For the interactive version

# Trees
library(networkD3)          # For radial network
library(collapsibleTree)    # Tree collapsible

#Read the file
ICD=read.table("WHO_disease_classification.txt.gz", sep="\t", header=T, quote = "")

# I take only the level1. It has a parent node number = 0
level1 = ICD  %>% filter(parent_id==0) %>%  select(-selectable) 
colnames(level1)=c("coding_L1", "meaning_L1", "node_L1", "parent_L1")

# Merge with the level2
level2 = ICD  %>% filter(parent_id>0 & parent_id<=22) %>%  select(-selectable) 
colnames(level2)=c("coding_L2", "meaning_L2", "node_L2", "parent_L2")
all = merge(level1, level2, by.x="node_L1", by.y="parent_L2", all.x=T)

# Merge with the level3
level3 = ICD  %>% filter(parent_id>22 & parent_id<=285) %>%  select(-selectable) 
colnames(level3)=c("coding_L3", "meaning_L3", "node_L3", "parent_L3")
all = merge(all, level3, by.x="node_L2", by.y="parent_L3", all.x=T)

# Merge with the level4
maxlevel4 = ICD$node_id[which(ICD$parent_id %in% level3$node_L3) ]  %>% max()
level4 = ICD  %>% filter(parent_id>285 & parent_id<=maxlevel4) %>%  select(-selectable) 
colnames(level4)=c("coding_L4", "meaning_L4", "node_L4", "parent_L4")
all = merge(all, level4, by.x="node_L3", by.y="parent_L4", all=T)

# Merge with the level5
# Do understand why some level5 have a node value very low. Example: node=4342 / code=I7000
level5 = ICD %>% mutate(nchar=nchar(as.character(coding))) %>% filter(nchar==5) %>%  select(-selectable, -nchar) 
colnames(level5)=c("coding_L5", "meaning_L5", "node_L5", "parent_L5")
all = merge(all, level5, by.x="node_L4", by.y="parent_L5", all.x=T)

# Just a small bug to remove for a few codes that have a X in their name
all = all[which(!is.na(all$node_L1)) , ]


# By hand, I create a table that describes the 22 major categories
mainCat=data.frame(
  node=seq(1,22),
  short=c("Infectious-Parasitic","Neoplasms","Blood-Immune","Nutritional","Mental","Nervous","Eye","Ear","Circulatory","Respiratory","Digestive","Skin","musculoskeletal", "Genitourinary","Childbirth","Perinatal","unclassified","Malformation","Injury","External-Causes","Factor-influencing","Special"),
  long=c("Certain infectious and parasitic diseases","Neoplasms"  ,"Diseases of the blood and blood-forming organs and certain disorders involving the immune mechanism"  ,"Endocrine, nutritional and metabolic diseases"  ,"Mental and behavioural disorders"  ,"Diseases of the nervous system"  ,"Diseases of the eye and adnexa" ,"Diseases of the ear and mastoid process"  ,"Diseases of the circulatory system"  ,"Diseases of the respiratory system"  ,"Diseases of the digestive system"  ,"Diseases of the skin and subcutaneous tissue"  ,"Diseases of the musculoskeletal system and connective tissue"  ,"Diseases of the genitourinary system"  ,"Pregnancy, childbirth and the puerperium"  ,"Certain conditions originating in the perinatal period" ,"Congenital malformations, deformations and chromosomal abnormalities"  ,"Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified" ,"Injury, poisoning and certain other consequences of external causes"  ,"External causes of morbidity and mortality"  ,"Factors influencing health status and contact with health services"  ,"Codes for special purposes")
)

# And I add these explicit names of highest groups (Level1)
all = merge(all, mainCat, by.x="node_L1", by.y="node", all.x=T)

# Order the table
all=all %>% arrange(node_L1, node_L2, node_L3, node_L4, node_L5)

# CHange name
ICD=all

# Save in 2 formats (R ans csv)
save(ICD, file="WHO_disease_classification_clean.R")
z <- gzfile("WHO_disease_classification_clean.csv.gz")
write.csv(ICD, z)

# Keep 2 levels
ICD_10 = ICD %>%  select(short, meaning_L2) %>% unique() %>% droplevels() 


#collapsibleTreeNetwork(
#  ICD_10,
#  attribute = "Title",
 # fill = "Color",
  #nodeSize = "leafCount",
  #collapsed = FALSE
#)

collapsibleTree(ICD_10, c("short", "meaning_L2"), linkLength="180", width="1900px", height="560px", fontSize = 11, zoomable = FALSE,  maxPercent = 3,fill="pink",fillByLevel = TRUE)

