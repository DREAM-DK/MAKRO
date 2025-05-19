# SMOOTHING OF VAR OUTPUTS
embeddedCode Python:
import dreamtools as dt
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.ndimage import gaussian_filter1d

# Load the database
db = dt.Gdx(r"Gdx/VAR%shockname%.gdx")

# List of variables to smooth
variables = [
    "pOil",          # Real oil price
    "qOilWorld",     # World oil production
    "qOilInvWorld",  # World oil inventories
    "qIndWorld",     # World industrial production
    "qUSImports",    # U.S. Real Imports
    "qUSInd",        # U.S. Industrial Production
    "pUSCPI",        # U.S. CPI
]

# Function to smooth data starting from shock period
def smooth_series_from_shock_period(series, sigma=3):
    """
    Smooth a time series using Gaussian filter, starting from shock period
    
    Parameters:
    - series: pandas Series to smooth
    - sigma: standard deviation for Gaussian kernel (controls smoothing intensity)
    
    Returns:
    - Smoothed series with original values before shock
    """
    # Create a copy to avoid modifying the original
    result = series.copy()
    
    # Get data from shock period onwards for smoothing
    data_to_smooth = series.iloc[%shock_period_foreign%+1:].values
    
    # Apply Gaussian filter to the data from shock period onwards
    if len(data_to_smooth) > 0:
        smoothed_data = gaussian_filter1d(data_to_smooth, sigma=sigma)
        
        # Replace values from shock period onwards with smoothed values
        result.iloc[%shock_period_foreign%+1:] = smoothed_data
    else:
        print(f"Warning: No data points for {series.name} after shock period. Using original data.")
    
    return result

# Smooth each variable and store it back in the database
for i, var in enumerate(variables):
    if var in db:
        original_series = db[var]
        db[var] = smooth_series_from_shock_period(original_series)

db.export("VAR%shockname%.gdx")

endEmbeddedCode