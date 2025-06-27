import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from efficient_apriori import apriori

def data_generator(filename):
    """
    Data generator, needs to return a generator to be called several times.
    """
    def data_gen():
        with open(filename) as file:
            for line in file:
                yield tuple(k.strip() for k in line.split(','))                  
    return data_gen
                
transactions = data_generator('mainSecICD10Comma2.tab')
                
itemsets, rules = apriori(transactions, min_support=0.01,  min_confidence=1)

# Print out every rule with 2 items on the left hand side,
# 1 item on the right hand side, sorted by lift
rules_rhs = filter(lambda rule: len(rule.lhs) == 3 and len(rule.rhs) == 1, rules)
for rule in sorted(rules_rhs, key=lambda rule: rule.lift):
  #with open ("rules.txt", 'w') as f:
    #f.write(rule)
    print(rule) # Prints the rule and its confidence, support, lift, ...rules = apriori(transactions, min_support=0.9, min_confidence=0.6)