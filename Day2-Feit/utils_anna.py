import numpy as np
import math
import re, os

# Returns Euclidean distance between two element positions in a grid layout
def distance (columns, i, j):   
    return np.sqrt( abs(np.divmod(j,columns)[0] - np.divmod(i,columns)[0])**2 + abs( np.divmod(i,columns)[1] - np.divmod(j,columns)[1])**2) 

def wpm(avg_iki_in_s):
    """ Computes the average words per minute that could be achieved with
    a keyboard from the given avg inter-key interval
    """
    if avg_iki_in_s == 0:
        return 0
    else:
        return (1.0/avg_iki_in_s*60)/5

def get_bigram_frequency(letters):
    """ 
        reads the .csv file containing the bigram frequencies
        Returns a map from bigrams to frequencies
    """ 
    bigramdist = {}
    f=open("resources/stylus.csv", 'r', encoding="utf-8")
    lines=f.readlines()
    for line in lines:
        if line[4] == "\"":
            line = re.sub('\"\t', '\t', line)
            line = re.sub('\"\"', '\"', line)
            line = re.sub('^\"', '', line)
        line = re.sub(r'\r', '', line)
        line = re.sub(r'\n', '', line)
        if len(line) > 1:
            parts = re.split ('\t', line)
            bigram = parts[0]
            if bigram[0] in letters and bigram[1] in letters:
                bigramdist[bigram[0], bigram[1]]=float(parts[1])
    #normalize
    s = np.sum(list(bigramdist.values()))

    for c,v in bigramdist.items():
        bigramdist[c] = v/s
    return bigramdist

def fittslawcost(i, j, D):
    """
        Returns the fitts law cost for pointing from key i to key j. 
        D: key distance
    """
    #Fitts parameter: 
    a = 0.0  # a and b paramater as used in [zhai et al. 2000] 
    b = 0.204
    arep = 0.127 #fixed mt for letter repetition    
    W = 1.0 #key width
    
    mt = -9999999
    if i == j:
        mt = arep + b * math.log(D/W + 1, 2) # repetition of the key, from the paper
    else:
        mt = a + b * math.log(D/W + 1, 2)
    return mt
