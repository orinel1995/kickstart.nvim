# External Dependencies (Windows)

## Base (required)
choco install git
choco install unzip
choco install tar
choco install gzip
choco install curl
choco install 7zip

## Used by this config (SQL, Python, HTML)
choco install python
pip install --user sqlformat autopep8 isort
choco install ripgrep
choco install fd

## Optional (warnings from :checkhealth / providers)
choco install powershell-core
choco install wget

## Optional (telescope-fzf-native, if you want the faster native FZF)
choco install make
# plus a C compiler (pick one):
# MSYS2 route:
# choco install msys2
# then in MSYS2:
# pacman -S mingw-w64-x86_64-gcc make
# MSVC route:
# choco install visualstudio2022buildtools
