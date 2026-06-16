# hapus semua isi folder tanpa hapus .gitkeep (linux mac os)
find . -mindepth 1 ! -name '.gitkeep' -delete

# hapus semua isi folder tanpa hapus .gitkeep (windows)
del /q /s * && cd . > .gitkeep