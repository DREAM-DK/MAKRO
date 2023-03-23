# Export pdf report
import base64
from xhtml2pdf import pisa

def figure_to_base64(figures, divider="""<div style="break-after:page"></div>"""):
    images_html = ""
    for figure in figures:
        image = str(base64.b64encode(figure.to_image(format="png", scale=3)))[2:-1]
        images_html += (f'<img src="data:image/png;base64,{image}">{divider}')
    return images_html
    
def create_html_report(template_file, images_html):
    with open(template_file,'r') as f:
        template_html = f.read()
    report_html = template_html.replace("{{ FIGURES }}", images_html)
    return report_html

def convert_html_to_pdf(source_html, output_path):
    with open(f"{output_path}", "w+b") as f:
        pisa_status = pisa.CreatePDF(source_html, dest=f)
    return pisa_status.err

def figures_to_pdf(figures, output_path):
    images_html = figure_to_base64(figures)
    report_html = create_html_report("template.html", images_html)
    return convert_html_to_pdf(report_html, output_path)