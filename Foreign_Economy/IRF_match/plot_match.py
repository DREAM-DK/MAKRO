import os 
import sys
import subprocess
import dreamtools as dt
import pandas as pd

## Set local paths
root = dt.find_root()
sys.path.insert(0, root)
import paths # Calls paths.py

## Set working directory
os.chdir(fr"{root}/Foreign_Economy")

### MONETARY POLICY
# Load the data 
file_path = r'Data/IRFs_RR_MPshock.xlsx'
df_rr = pd.read_excel(file_path) 
df_rr_bounds = pd.read_excel(file_path, sheet_name='GammaBands')
scale = 1  # scale so that on impact os 25 bps

df_rr = df_rr.rename(columns={
    'ffer': 'i',
    '100*(log(rGDP_US))': 'y',
    '100*(log(GPDI_US))': 'inv',
    '100*(log(PCE_US))': 'pi',
    '100*(log(C_US))': 'c',
})

df_rr *= scale

rename_map = {
    'ffer': 'i',
    '100*(log(rGDP_US))': 'y',
    '100*(log(GPDI_US))': 'inv',
    '100*(log(PCE_US))': 'pi',
    '100*(log(C_US))': 'c',
    '100*(log(W_real_US))': 'w_real',
}

# Generate new column names while keeping '_Lower' and '_Upper'
df_rr_bounds = df_rr_bounds.rename(columns={
    old_col: rename_map[base] + '_' + suffix
    for old_col in df_rr_bounds.columns
    for base, suffix in [old_col.rsplit('_', 1)]  # Split only at the last '_'
})

df_rr_bounds *= scale 

import dreamtools as dt
db_base = dt.Gdx(r"Gdx/steady_state_calibration.gdx")
db = dt.Gdx(r"Gdx/eps_rshock.gdx")
from matplotlib import pyplot as plt
db_base['Pi'] = db_base['pi'] + 1
db['Pi'] = db['pi'] + 1
Tplot = 12
# List of variables to plot
variables = ['y', 'c', 'pi', 'inv', 'i']
shift = 6 # Shift model data by 3 quarters to align with empirical data
# Assuming db_base and db are dictionaries containing steady state and shocked values respectively
for var in variables:
    steady_state = db_base[var]
    shocked = db[var]
    
    # Dynamically generate the variable name (dC, dY, dPi, dinv, di)
    d_var = f'd{var}'
    
    # Calculate the difference and assign the result to the dynamically generated variable
    globals()[d_var] = 100 * (shocked - steady_state) / steady_state
    if var=='i':
        globals()[d_var] = 100 * (shocked - steady_state)
    if var=='pi':
        globals()[d_var] = 100 * shocked
# Create figure with subplots
# Create subplots with 3 rows x 2 columns
fig, axes = plt.subplots(2, 3, figsize=(14, 7), layout='constrained')
# fig.suptitle("Impulse Response Functions, Interest Rate Shock", fontsize=16, fontweight='bold')

# Flatten the axes array and remove the last subplot
axes = axes.flatten()[:-1]  # Remove last subplot

# Helper function to format each subplot
def format_plot(ax, title):
    ax.set_title(title, fontsize=16)
    ax.set_xlabel('Quarters', fontsize=16)
    ax.set_ylabel('Pct. difference to s.s.', fontsize=16)
    ax.axhline(0, color='red', linestyle='--', linewidth=1)  # Zero reference line
    ax.grid(True, linestyle=':', linewidth=0.7, alpha=0.7)
    ax.set_xlim([0, Tplot-1])

# Helper function to plot IRFs along with empirical data and confidence bounds from df_bounds.
def plot_irf(ax, model_data, emp_data, var, label):
    model_data_shifted = model_data.shift(-shift) # Shift model data by one to align with empirical data
    ax.plot(model_data_shifted[0:Tplot], label=f'Model {label}', color='black', linewidth=1.5)
    ax.plot(emp_data[:Tplot], label=f'Empirical {label}', linestyle='dashed', color='blue', linewidth=1.5)
    ax.legend()  # Activate the legend
    # Extract lower and upper bounds
    lower_bound = df_rr_bounds[var + '_Lower'][:Tplot]
    upper_bound = df_rr_bounds[var + '_Upper'][:Tplot]
    
    ax.fill_between(range(Tplot), lower_bound, upper_bound, color='blue', alpha=0.2, label='95% CI')

# Assign subplots and plot each IRF
titles = [
    'Output Response', 'Consumption Response', 
    'Inflation Response', 'Investment Response',
    'Nominal Interest Rate (Bonds) Response'
]
variables = ['y', 'c', 'pi', 'inv', 'i']
data_series = [dy, dc, dpi, dinv, di]
labels = ['$dY$', '$dC$', '$d\pi$', '$\text{inv}$', '$drb$']

for ax, title, var, data, label in zip(axes, titles, variables, data_series, labels):
    format_plot(ax, title)
    plot_irf(ax, data, df_rr[var], var, label)
plt.savefig("IRF_r_shock.pdf", format="pdf", bbox_inches="tight")
plt.show()