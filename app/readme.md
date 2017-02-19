requires: 
jq library
git library
ruby?

wget {packageLocation}

tar -czv {package}

cd {package}
sudo ./hermes.sh install

now run hermes from anywhere