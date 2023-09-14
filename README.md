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
sudo apt-get install --no-install-recommends -y git autoconf automake pkg-config build-essential cmake liblua5.1-0-dev libmysqlclient-dev libxml2-dev libgmp3-dev libboost-filesystem-dev libboost-regex-dev libboost-thread-dev
```

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
