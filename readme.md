requires: 
jq library
git library
ruby?

wget {packageLocation}

tar -czv {package}

cd {package}
sudo ./hermes.sh install

now run hermes from anywhere

wget https://github.com/dking3876/hermes/archive/master.zip