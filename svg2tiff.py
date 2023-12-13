import subprocess
import os
import io
import tkinter as tk
from tkinter import filedialog

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

try:
    import cairosvg
except ImportError:
    install('cairosvg')

try:
    from PIL import Image
except ImportError:
    install('pillow')
    
from PIL import Image
import cairosvg

# 将SVG转换为TIFF的函数
def convert_svg_to_tiff(svg_filename, tiff_filename, dpi=300):
    png_data = cairosvg.svg2png(url=svg_filename)
    image = Image.open(io.BytesIO(png_data))
    image.save(tiff_filename, format='TIFF', dpi=(dpi, dpi))

# 将文件夹中的所有SVG转换为TIFF
def convert_all_svgs_in_folder(folder_path, dpi):
    for filename in os.listdir(folder_path):
        if filename.endswith(".svg"):
            svg_filename = os.path.join(folder_path, filename)
            tiff_filename = os.path.join(folder_path, os.path.splitext(filename)[0] + '.tiff')
            convert_svg_to_tiff(svg_filename, tiff_filename, dpi)
            print(f"Converted {svg_filename} to {tiff_filename}")

# 使用tkinter选择文件夹
def select_folder():
    root = tk.Tk()
    root.withdraw() # 不显示主窗口
    folder_selected = filedialog.askdirectory()
    return folder_selected

# 获取文件夹路径和DPI
folder_path = select_folder()
dpi = int(input("Enter DPI: "))

convert_all_svgs_in_folder(folder_path, dpi)

