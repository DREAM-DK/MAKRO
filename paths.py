# Change the paths to the R and GAMS installations on your system
gams_path = r"C:/GAMS/51"


import os
import platform

if platform.system() != "Linux":    
    def set_environment_path(gams_path, r_path=None):
        """
        Set the environment variables R_HOME, RSCRIPT, GAMSDIR, and GAMS.

        Parameters:
        r_path (str): Path to the R installation directory.
        gams_path (str): Path to the GAMS installation directory.
        """
        # Ensure the paths use the correct format
        gams_path = os.path.abspath(gams_path)
        r_path = os.path.abspath(r_path)

        extension = ".exe" if os.name == "nt" else ""
    
        # Construct the paths using os.path.join for platform independence
        gams_executable_path = os.path.join(gams_path, f"gams{extension}")
        assert os.path.exists(gams_executable_path), f"GAMS executable not found at {gams_executable_path}"
        os.environ["GAMSDIR"] = gams_path
        os.environ["GAMS"] = gams_executable_path

        if r_path is not None:
            rscript_path = os.path.join(r_path, "bin", f"Rscript{extension}")
            assert os.path.exists(rscript_path), f"Rscript not found at {rscript_path}"       
            # Set the environment variables
            os.environ["R_HOME"] = r_path
            os.environ["RSCRIPT"] = rscript_path
   
    set_environment_path(gams_path)