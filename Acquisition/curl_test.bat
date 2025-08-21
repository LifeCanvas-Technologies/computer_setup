
:: ===== EDIT THESE =====
set "file_id=1XY94J-bZVZIXT-Jbh_C8m0ooOz3YtyYn"
set "outfile=install_files.tar.gz"
set top_directory="C:\Program Files\LifeCanvasTech"
:: ======================

curl -L "https://drive.usercontent.google.com/download?export=download&confirm=t&id=%file_id%" -o %outfile%
pause
tar -xzvf %outfile% -C %top_directory%
pause

del %outfile%