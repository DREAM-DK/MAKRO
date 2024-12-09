""" The following file does two things; 
    1. compares changes in IO cells between two years and two baseline .gdx files
    2. compares ARIMA forecasts with drift or trend reversion between two forecasts (e.g. 
       useful to check how ARIMA's change when updating data). """

import os
import dreamtools as dt
import pandas as pd
import numpy as np
from PyPDF2 import PdfMerger
from matplotlib import pyplot as plt
os.chdir(r"C:\Users\B200946\Documents\GitHub\ARIMA_compare\MAKRO-dev\Analysis\Baseline") 
plt.rcParams['axes.grid'] = True
plt.rc('lines', linewidth=2.0)

# IO comparison years
new_year = 2018
ref_year = 2017

# 1. compare IO cells
r = dt.Gdx("..//..//Model/Gdx/previous_deep_calibration.gdx") # reference
n = dt.Gdx("..//..//Model/Gdx/deep_calibration.gdx") # new

qIO_changed_cells = n.qIO.loc[:,:,new_year][r.qIO.loc[:,:,ref_year] == 0] != 0
with pd.option_context('display.max_rows', None,
                       'display.max_columns', None,
                       'display.precision', 3,
                       ):
    print(qIO_changed_cells[qIO_changed_cells == True]) # check if there is any change at all

qIO_pct_change = (n.qIO.loc[:,:,new_year][r.qIO.loc[:,:,ref_year] != 0] - r.qIO.loc[:,:,ref_year][r.qIO.loc[:,:,2017] != 0]) \
                 / r.qIO.loc[:,:,ref_year][r.qIO.loc[:,:,ref_year] != 0] * 100 # pct. change

with pd.option_context('display.max_rows', None,
                       'display.max_columns', None,
                       'display.precision', 3,
                       ):
    print(qIO_pct_change)

np.max(qIO_pct_change) # check max pct. change

# 2. compare ARIMA's
ARIMA_input = dt.Gdx("..//..//Model/Gdx/ARIMA_forecast_input.gdx")
r = dt.Gdx("..//..//Model/Gdx/previous_ARIMA_forecasts.gdx")
n = dt.Gdx("..//..//Model/Gdx/ARIMA_forecasts.gdx")


# loop through multi-indeces etc...
varnames_single = [] # varname list
varnames_multiindex1 = [] # varname list
varnames_multiindex2 = [] # varname list
varnames_multiindex1_noset = [] # varnames without set
varnames_multiindex2_noset = [] # varnames without set
keys_multiindex1 = [] # set keys, same length as varname list
keys_multiindex2 = [] # set keys, same length as varname list
drift_year = 2020 # year to check drift/trend reversion from

for i in r.keys():
    if i == 'RVTAFGEU2VTAFG':
        print('Exception for RVTAFGEU2VTAFG') # not callable
    else:
        if isinstance(n[i].index, pd.MultiIndex):
            if len(n[i].index.levshape)>2:
                keys = [*set(list(n[i].droplevel(2).keys()))]
                for j in keys:
                    drift_new = not (n[i][j[0]][j[1]].loc[drift_year] == n[i][j[0]][j[1]].loc[drift_year:]).all()
                    drift_old = not (r[i][j[0]][j[1]].loc[drift_year] == r[i][j[0]][j[1]].loc[drift_year:]).all()
                    if drift_new or drift_old: # check if drift in new or old forecasts
                        varnames_multiindex2.append(i+"["+str(j[0])+","+str(j[1])+"]")
                        varnames_multiindex2_noset.append(i)
                        keys_multiindex2.append(j)
            else:
                keys = [*set(list(n[i].droplevel(1).keys()))]
                for j in keys:
                    drift_new = not (n[i][j].loc[drift_year] == n[i][j].loc[drift_year:]).all()
                    drift_old = not (r[i][j].loc[drift_year] == r[i][j].loc[drift_year:]).all()
                    if drift_new or drift_old: # check if drift in new or old forecasts
                        varnames_multiindex1.append(i+"["+str(j)+"]")
                        varnames_multiindex1_noset.append(i)
                        keys_multiindex1.append(j)
        else:
            drift_new = not (n[i].loc[drift_year] == n[i].loc[drift_year:]).all()
            drift_old = not (r[i].loc[drift_year] == r[i].loc[drift_year:]).all()
            if drift_new or drift_old: # check if drift in new or old forecasts
                varnames_single.append(i)

# first single variables
ncols = 4
num = len(varnames_single)
nrows = num//ncols+1
if num%ncols == 0: nrows -= 1 

fig = plt.figure(figsize=(6*ncols,4*nrows),dpi=100)

for i,varname in enumerate(varnames_single):

    ax = fig.add_subplot(nrows,ncols,i+1)
    title = varname
    ax.set_title(title,fontsize=14)
    # find variable name for input 
    input_keys = list(ARIMA_input.keys())
    input_keys_cap = [x.upper() for x in input_keys]
    ax.plot(ARIMA_input[input_keys[input_keys_cap.index(varname)]].loc[1983:].replace(0, np.nan),color='black') # make 0 NA
    ax.plot(r[varname],label="Old forecast",color='red')
    ax.plot(n[varname],label="New forecast",color='blue')
    ax.legend(loc='upper right')
    ax.set_xlabel('Year')
    ax.set_xlim(1983,n[varname].index[-1])

fig.tight_layout()
plt.savefig('Output//ARIMA_drift_noset.pdf')

# next multi-index variables, single
ncols = 4
nrows = 6

start = 0 # subplot counter

len_varnames = len(varnames_multiindex1)/20
if not len_varnames.is_integer():
    len_varnames = round(len_varnames) + 1
else:
    len_varnames = int(len_varnames)

for i in range(len_varnames):
    fig = plt.figure(figsize=(6*ncols,4*nrows),dpi=100)

    for j,varname in enumerate(varnames_multiindex1[start:start+20]):  
        
        ax = fig.add_subplot(nrows,ncols,j+1)
        j += start
        title = varname
        ax.set_title(title,fontsize=14)
        input_keys = list(ARIMA_input.keys())
        input_keys_cap = [x.upper() for x in input_keys]
        ax.plot(ARIMA_input[input_keys[input_keys_cap.index(varnames_multiindex1_noset[j])]][keys_multiindex1[j]].loc[1983:].replace(0, np.nan),color='black') # make 0 NA
        ax.plot(r[varnames_multiindex1_noset[j]][keys_multiindex1[j]],label="Old forecast",color='red')
        ax.plot(n[varnames_multiindex1_noset[j]][keys_multiindex1[j]],label="New forecast",color='blue')
        ax.legend(loc='upper right')
        ax.set_xlabel('Year')
        ax.set_xlim(1983,n[varnames_multiindex1_noset[j]][keys_multiindex1[j]].index[-1])
    fig.tight_layout()
    plt.savefig('Output//ARIMA_drift_1set' + str(i) + '.pdf')
    start += 20

# next multi-index variables, double
start = 0 # subplot counter

len_varnames = len(varnames_multiindex2)/20
if not len_varnames.is_integer():
    len_varnames = round(len_varnames) + 1
else:
    len_varnames = int(len_varnames)
    
for i in range(len_varnames):
    fig = plt.figure(figsize=(6*ncols,4*nrows),dpi=100)

    for j,varname in enumerate(varnames_multiindex2[start:start+20]):  
        
        ax = fig.add_subplot(nrows,ncols,j+1)
        j += start
        title = varname
        ax.set_title(title,fontsize=14)
        input_keys = list(ARIMA_input.keys())
        input_keys_cap = [x.upper() for x in input_keys]
        ax.plot(ARIMA_input[input_keys[input_keys_cap.index(varnames_multiindex2_noset[j])]][keys_multiindex2[j]].loc[1983:].replace(0, np.nan),color='black') # make 0 NA
        ax.plot(r[varnames_multiindex2_noset[j]][keys_multiindex2[j]],label="Old forecast",color='red')
        ax.plot(n[varnames_multiindex2_noset[j]][keys_multiindex2[j]],label="New forecast",color='blue')
        ax.legend(loc='upper right')
        ax.set_xlabel('Year')
        ax.set_xlim(1983,n[varnames_multiindex2_noset[j]][keys_multiindex2[j]].index[-1])
    fig.tight_layout()
    plt.savefig('Output//ARIMA_drift_2sets' + str(i) + '.pdf')
    start += 20

# combine PDFs
if os.path.isfile("Output//ARIMA_comparison.pdf"):
    os.remove("Output//ARIMA_comparison.pdf")
x = [a for a in os.listdir("Output") if a.endswith(".pdf")]
pdf_list = ["Output//" + i for i in x]
merger = PdfMerger()
 
for pdf in pdf_list:
    merger.append(open(pdf, 'rb'))
 
with open("Output//ARIMA_comparison.pdf", "wb") as fout:
    merger.write(fout)

# delete single pdf files
if "Output//ARIMA_comparison.pdf" in pdf_list:
    pdf_list.remove("Output//ARIMA_comparison.pdf") 
    for dir in pdf_list:
        os.remove(dir) 
else:
    for dir in pdf_list:
        os.remove(dir) 