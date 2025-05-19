# Change the paths to the GAMS installation on your system.
gams_path = r"C:/GAMS/49"


import os

def set_environment_path(gams_path):
    """
    Set the environment variables GAMSDIR, and GAMS.

    Parameters:
    gams_path (str): Path to the GAMS installation directory.
    """
    # Ensure the paths use the correct format.
    gams_path = os.path.abspath(gams_path)

    extension = ".exe" if os.name == "nt" else ""
    
    # Construct the paths using os.path.join for platform independence
    gams_executable_path = os.path.join(gams_path, f"gams{extension}")
    assert os.path.exists(gams_executable_path), f"GAMS executable not found at {gams_executable_path}"
    
    # Set the environment variables
    os.environ["GAMSDIR"] = gams_path
    os.environ["GAMS"] = gams_executable_path

set_environment_path(gams_path)