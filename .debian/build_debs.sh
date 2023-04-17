#!/usr/bin/env bash
cd .debian || exit
chmod 0755 DEBIAN
mkdir -p build/usr/bin
cp ../out/Swift-MesonLSP build/usr/bin
dpkg-deb --build build
cp build.deb /Swift-MesonLSP-ubuntu-18.04.deb
rm build.deb usr/bin/Swift-MesonLSP
cp ../out1/Swift-MesonLSP build/usr/bin
dpkg-deb --build .
cp build.deb /Swift-MesonLSP-ubuntu-20.04.deb
rm .deb usr/bin/Swift-MesonLSP
cp ../out2/Swift-MesonLSP build/usr/bin
dpkg-deb --build .
cp build.deb /Swift-MesonLSP-ubuntu-22.04.deb
rm build.deb usr/bin/Swift-MesonLSP
