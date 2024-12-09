# Export pdf report
import base64
from xhtml2pdf import pisa
import plotly
plotly.io.kaleido.scope.mathjax = None

def figures_to_html(figures, divider="""<div style="break-after:page"></div>"""):
    """
    Convert a list of Plotly figures to HTML format with embedded images.

    Parameters:
    - figures (list): A list of Plotly figure objects to be converted.
    - divider (str): An optional HTML divider string to be inserted between the figures.
                     Default is a div with a page break style.

    Returns:
    - str: An HTML string containing the figures as embedded images separated by the divider.

    Example:
    >>> import plotly.graph_objects as go
    >>> fig1 = go.Figure(data=[go.Scatter(x=[1, 2, 3], y=[4, 5, 6])])
    >>> fig2 = go.Figure(data=[go.Scatter(x=[1, 2, 3], y=[6, 5, 4])])
    >>> html_figures = figures_to_html(figures=[fig1, fig2])
    """
    html_figures = ""
    for figure in figures:
        img_bytes = figure.to_image(format="png", scale=3)
        img_base64 = base64.b64encode(img_bytes).decode("utf-8")
        html_figures += f'<img src="data:image/png;base64,{img_base64}">'
        html_figures += divider
    return html_figures

def convert_html_to_pdf(source_html, output_path):
    with open(f"{output_path}", "w+b") as f:
        pisa_status = pisa.CreatePDF(source_html, dest=f)
    return pisa_status.err

def figures_to_pdf(figures, output_path):
    html_figures = figures_to_html(figures)
    report_html = fr"""
<html>
<head>
</head>
	
<body>
	{html_figures}
</body>
</html>
"""
    return convert_html_to_pdf(report_html, output_path)