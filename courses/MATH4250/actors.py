#!/usr/bin/env python
# coding: utf-8

# In[44]:


# Student Name: Bobby Sokhi 
# Student Number: 100355678
# Date: October 3 2022

# Importing the following packages for this assignment:

from os.path import basename, exists
import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
import seaborn as sns
import gzip

# Defining a function download that takes in a single parameter
# i.e url and uploads it to our kernel. If the file is not found 
# the function throws an exception.

def download(url):
    file_name = basename(url)
    if not exists(file_name):
        from urllib.request import urlretrieve
        local, _ = urlretrieve(url, file_name)
        print('File has been downloaded: ' + local)
        
# I was not able to extract the data from the actual website 
# so I extracted the bottom 2 files from the author's github.

download('https://github.com/AllenDowney/ThinkComplexity2/raw/master/data/actor.dat.gz')
download('https://github.com/AllenDowney/ThinkComplexity2/raw/master/notebooks/utils.py')

from utils import decorate


# In[28]:


# Defining a function that takes in 2 parameters i.e 
# 'filename' and 'n'. This function reads in the data 
# from the file and iterates through each line of the file.
# If there is a connection between any of those lines, we 
# store the edges i.e lines into a list and form a graph.

def read_actor_network(filename, n=None):
    G = nx.Graph()
    with gzip.open(filename) as f:
        for i, line in enumerate(f):
            nodes = [int(x) for x in line.split()]
            G.add_edges_from(all_pairs(nodes))
            if n and i >= n:
                break
    return G

# Defining a function that takes in a single parameters 'nodes'.
# Initially, the function has an empty list that is essentially going to be 
# used to store all of the random edges. The function then compares the 
# index positions of the list that holds our nodes using control flow and 
# then returns the list for edges between u and v.

def all_pairs(nodes):
    for i, u in enumerate(nodes):
        for j, v in enumerate(nodes):
            if i < j:
                yield u, v
                
# Defining a function that takes in a single parameter which in this 
# case in a 'Graph' and then returns the degree for each line in the 
# file.

def degrees(G):
    return [G.degree(u) for u in G]


# In[46]:


# Q1: Computing the number of actors in the graph and also displaying
# the average degree of the graph.

actors = read_actor_network('actor.dat.gz', n=10000)
length_of_actors = len(actors)
print(length_of_actors)

for nodes in nx.connected_components(actors):
    if len(nodes) > 100:
        print(len(nodes))


# In[30]:


# Computing the average degree: 

ds = degrees(actors)
avg_degree = np.mean(ds)
print(avg_degree)


# In[50]:


# Q2: Plotting the PMF of the degree on a log-log scale.

try:
    import empiricaldist
except ImportError:
    get_ipython().system('pip install empiricaldist')
    
from empiricaldist import Pmf

plt.figure(figsize=(8,4))
options = dict(ls='', marker='*')

plt.subplot(1,2,1)
plt.plot([20, 1000], [5e-2, 2e-4], color='red', linestyle='dashed')

pmf = Pmf.from_seq(ds, name='actors')
pmf.plot(**options)
decorate(xlabel='Degree', ylabel='PMF',
         xscale='log', yscale='log')

# Looking at the PMF of the degree on the log - log scale it does 
# suggest that we have a straight line that corresponds with the 
# definition of having a power law.


# In[51]:


# Q: Plotting the CDF of the degree on a log-x scale:

from empiricaldist import Cdf

cdf = Cdf.from_seq(ds, name='actors')
cdf.plot()
decorate(xlabel='Degree', ylabel='CDF', xscale='log')

# The CDF on a log - x scale looks like a log function that 
# is heavily distributed to the right i.e it is skewed to 
# to the right.


# In[38]:


# Q: Plotting the CDF of the degree on a log - log scale.

(1-cdf).plot()
decorate(xlabel='Degree', ylabel='CDF',
                 xscale='log', yscale='log')

# The CDF on the log log scale does not seem to have  a straight 
# line behaviour as we would expect from a power law. However, this
# graph does look like it has a heavy tailed distribution i.e 
# skewed to the left.
