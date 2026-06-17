# import sys
# import subprocess
# subprocess.run([sys.executable, "-m", "pip", "install", "PdfMerger"], check=True)

from pypdf import PdfWriter

import shutil

with PdfWriter() as merger:
  merger.append("FrontPages&BackPage.pdf", pages=(0, 3)) # First 3 pages
  merger.append("Documentation.pdf")
  merger.append("FrontPages&BackPage.pdf", pages=(4, 5)) # Page 6

  merger.write("MergedDocumentation.pdf")
