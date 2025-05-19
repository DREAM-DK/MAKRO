import pickle as pkl
import numpy as np
import glob
import dreamtools as dt
import os

with open(r"Savepoints/foreign_economy.pkl", 'rb') as f:
    macros = pkl.load(f)

def quarterly_to_yearly(data):
    """Convert quarterly data to yearly by taking the mean of groups of 4 quarters."""
    # Find non-zero data
    T = int(macros[-2]['end_foreign'])
    tstart = int(macros[-2]['shock_period_foreign'])
    
    # Create yearly data array
    yearly_data = np.zeros(round(T/4))
    
    # Take mean of each group of 4 quarters
    for j in range(round(T/4)):
        yearly_data[j] = np.mean(data[tstart + j*4:tstart + (j+1)*4])
        
    return yearly_data, round(T/4)

# Variable mappings for VAR files
VAR_MAPPINGS = {
    "pOil": "Real oil price",
    "qOilWorld": "World oil production",
    "qOilInvWorld": "World oil inventories",
    "qIndWorld": "World industrial production",
    "qUSImports": "U.S. Real Imports",
    "qUSInd": "U.S. Industrial Production",
    "pUSCPI": "U.S. CPI"
}

# Process shock files
for fname in glob.glob(r"Gdx/*shock*.gdx"):
    if "zeroshock" in fname:
        continue
        
    # Load source data and create output database
    db_shock = dt.Gdx(fname)
    db = dt.GamsPandasDatabase()
    
    # Convert quarterly to yearly data
    dYF, years = quarterly_to_yearly(db_shock.dYFq)
    dPF, _ = quarterly_to_yearly(db_shock.dPFq)
    dRF, _ = quarterly_to_yearly(db_shock.dRFq)

    # Create parameters and sets
    tau = db.create_set("tau", range(years), "År efter stød (inkl. stødår)")
    db.create_parameter("dYF_", [tau], "deviation in foreign output from baseline")
    db.create_parameter("dPF_", [tau], "deviation in foreign price from baseline")
    db.create_parameter("dRF_", [tau], "deviation in foreign real rate from baseline")
    
    # Insert data
    db.dYF_[:] = dYF
    db.dPF_[:] = dPF
    db.dRF_[:] = dRF

    # Export results
    db.export(fname.replace("shock", "").replace(".gdx", "_deviations.gdx"))

# Process VAR files
for fname in glob.glob(r"Gdx/*VAR*.gdx"):
    # Skip files that already have "_yearly" in their name
    if "_yearly" in fname:
        continue
        
    # Check if a yearly file already exists
    base_fname = os.path.basename(fname).replace(".gdx", "")
    yearly_fname = f"{base_fname}_yearly.gdx"
    yearly_path = os.path.join("Gdx", yearly_fname)
    
    # Check if yearly file exists
    if os.path.exists(yearly_path):
        continue
            
    db_shock = dt.Gdx(fname)
    db = dt.GamsPandasDatabase()
    
    processed = False
    
    # Process each variable
    for var_name, var_description in VAR_MAPPINGS.items():
        if hasattr(db_shock, var_name):
            processed = True
            var_data_q = getattr(db_shock, var_name)
            
            # Convert to yearly
            var_data_y, years = quarterly_to_yearly(var_data_q)
            
            # Create parameter and insert data
            tau = db.create_set("tau", range(years), "År (yearly)")
            db.create_parameter(var_name, [tau], var_description)
            db[var_name][:] = var_data_y
    
    # Export if any variables were processed
    if processed:
        db.export(yearly_path)