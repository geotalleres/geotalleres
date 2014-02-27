set -e

cd /tmp
git clone https://github.com/geotalleres/geotalleres.git
cd geotalleres
git submodule update --init
make html
ls | grep -v build | xargs rm -fr
git checkout gh-pages 
cp -R build/html/* .
rm -fr build/
git add -A
git commit -m "actualizacion"
git push
