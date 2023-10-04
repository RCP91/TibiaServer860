## Libraries for Visual Studio 2022 (using vcpkg)
- x32:
```
.\vcpkg install luajit libmariadb libxml2 gmp boost-filesystem boost-regex boost-thread boost-asio boost-foreach boost-any openssl
```

- x64:
```
.\vcpkg install --triplet x64-windows luajit libmariadb libxml2 gmp boost-filesystem boost-regex boost-thread boost-asio
```

## Build instruction for Ubuntu 22.04

```
sudo apt-get update
```

```
sudo apt install libboost-all-dev libgmp3-dev liblua5.1-0 liblua5.1-0-dev  lua5.1 libxml2-dev libxml++2.6-dev zlib1g-dev zlib1g libcrypto++-dev libcrypto++6 libssl-dev libmariadb-dev libmariadb-dev-compat cpp gcc g++ make autoconf
``` 
Test version >> libcrypto++6 or remove number 6 error installing.

```
git clone https://github.com/RCP91/TibiaServer860.git
```

```
cd /TibiaServer860 && mkdir build && cd build
```

```
cmake ..
```

```
make -j$(grep processor /proc/cpuinfo | wc -l)
```
