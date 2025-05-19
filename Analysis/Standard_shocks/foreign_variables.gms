embeddedCode Python:
    import dreamtools as dt
    import pandas as pd
    import numpy as np
    import glob
    # loop over deviations
    shock_files = [file for file in glob.glob(r"../../Foreign_Economy/Gdx/*deviation*.gdx")]
    sets = dt.Gdx(r"..\..\Model\Gdx\sets.gdx")

    for shock_file in shock_files:
        db = dt.Gdx(shock_file)
        t = sets.get("t")
        t = db.create_set("t", range(t[0][0], t[0][-1]+1), "Comprehensive time set that includes all periods used anywhere")
        dYF_ = db.create_parameter("dYF", [t], "deviation in foreign output from baseline, MAKRO t-set")
        dPF_ = db.create_parameter("dPF", [t], "deviation in foreign price from baseline, MAKRO t-set")
        dRF_ = db.create_parameter("dRF", [t], "deviation in foreign real rate from baseline, MAKRO t-set")
        # Insert data
        db.dYF[:] = 0
        db.dPF[:] = 0
        db.dRF[:] = 0
        db.dYF[db.dYF.index >= %shock_year%] = np.array([db.dYF_[0:len(db.dYF[db.dYF.index >= %shock_year%])]])[0]
        db.dPF[db.dPF.index >= %shock_year%] = np.array([db.dPF_[0:len(db.dPF[db.dPF.index >= %shock_year%])]])[0]
        db.dRF[db.dRF.index >= %shock_year%] = np.array([db.dRF_[0:len(db.dRF[db.dRF.index >= %shock_year%])]])[0]
        db.export(shock_file)

    var_files = [file for file in glob.glob(r"../../Foreign_Economy/Gdx/*yearly*.gdx")]

    try:
        for var_file in var_files:
            db = dt.Gdx(var_file)
            t = sets.get("t")
            # Get all variable names except 'tau'
            var_names = [name for name in db.keys() if name != 'tau']
            t = db.create_set("t", range(t[0][0], t[0][-1]+1), "Comprehensive time set that includes all periods used anywhere")
            
            # Process each variable
            for var_name in var_names:
                # Create parameter with MAKRO t-set suffix
                makro_var = f"{var_name}"  
                db.create_parameter(var_name[:-1], [t], f"deviation in {var_name[:-1]} from baseline")
                # Set initial values to 0
                db[var_name[:-1]][:] = 0
                # Insert data for periods >= %shock_year%
                indices = db[var_name[:-1]].index >= %shock_year%
                values_length = len(db[var_name[:-1]][indices])
                makro_values = np.array([db[makro_var][0:values_length]])[0]
                db[var_name[:-1]][indices] = makro_values
            
            # Export the updated database
            db.export(var_file)
    except Exception as e:
        print(f"Already transformed dataset: {e}")
    finally:
        print("Processing completed.")
endEmbeddedCode