# Takes in new parameter guesses for empirical IRF to model IRF matching
@load(All, "Gdx\matching_file.gdx");

# Set earlier terminal year to speed up calibration
$SETGLOBAL terminal_year 2060

# Disable tests
$SETGLOBAL run_tests 0

# Run static calibration 
$IMPORT static_calibration.gms;