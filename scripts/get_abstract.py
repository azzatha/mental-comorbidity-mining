
import pandas as pd

alltxt={}

def get_title(txt):
    index=txt.find("TI  - ")
    txt=txt[index:]
    index2=txt.find("PG  - ")
    title=txt[:index2]
    title = title.replace('\n', '')
    title = title.replace('     ', '')
    #print(title)
    #return txt[index2+1:]
    
    indexa=txt.find("AB  - ")
    txta=txt[indexa:]
    index2a=txta.find("FAU - ")
    abstract=txta[:index2a]
    abstract = abstract.replace('\n', '')
    abstract = abstract.replace('     ', '')
    #print(title)
    
    print(txt[index2a+1:])
    return txt[index2a+1:]
    #return abstract
    #return title

def get_abstact(txt):
    index=txt.find("AB  - ")
    txt=txt[index:]
    index2=txt.find("FAU - ")
    abstract=txt[:index2]
    abstract = abstract.replace('\n', '')
    abstract = abstract.replace('     ', '')
    #print(abstract)
    #return txt[index2+1:]
    return abstract

f=open("pubmed_result_all_apstract.txt")
fname ="pubmed_result_all_apstract.txt"
t = 0
txt=f.read()
title=''
print("here")
with open(fname, 'r') as f:
    for line in f:
        if (line.startswith("TI")):
            index=txt.find("TI  - ")
            txt=txt[index:]
            index2=txt.find("PG  - ")
            title=txt[:index2]
            title = title.replace('\n', '')
            title = title.replace('     ', '')
        if (line.startswith("AB")):
            indexa=txt.find("AB  - ")
            txta=txt[indexa:]
            index2a=txta.find("FAU - ")
            abstract=txta[:index2a]
            abstract = abstract.replace('\n', '')
            abstract = abstract.replace('     ', '')
            txt= txt[index2+1:]
            alltxt[title] = abstract
#print("Number of lines:")
#print(num_lines)
#print(alltxt)
print("here2")
all = pd.DataFrame.from_dict(alltxt, orient='index')
all=all.reset_index()
all=all.rename(columns={'index':'title',0:'abstract'})
#print(all.head())
print("here3")
all.to_csv("allText.csv", sep='\t', index=False)
