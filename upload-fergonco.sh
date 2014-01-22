set -e

cd /tmp
git clone --recursive https://github.com/geotalleres/geotalleres.git
cd geotalleres
make html
ncftpput -R -v -u geotaller.fergonco.es -p Ge0taller ftp.fergonco.es . build/html/*
