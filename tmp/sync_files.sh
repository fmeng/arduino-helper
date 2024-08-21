#!/bin/bash

# 更新索引
rm -rf ../arduino_index/*
rm -rf *.tar.bz2
curl -o "package_index.tar.bz2" 'https://downloads.arduino.cc/packages/package_index.tar.bz2'
curl -o "library_index.tar.bz2" 'https://downloads.arduino.cc/libraries/library_index.tar.bz2'
mv *.tar.bz2 ../arduino_index/
find ../arduino_index/ -type f | grep -v DS_Store | grep -v checksums.md5 | sort | xargs md5 -r > ../arduino_index/checksums.md5

# 更新arduino ide
rm -rf ../arduino_ide/*
rm -rf arduino-ide_*
arduino_ide_url="https://github.com/arduino/arduino-ide/releases/latest"
version=`curl -s -I -L -o /dev/null -w "%{url_effective}" ${arduino_ide_url} | awk -F'/tag/' '{print $2}'`
download_url="https://github.com/arduino/arduino-ide/releases/download/${version}/arduino-ide_${version}_Windows_64bit.exe"
file_name="arduino-ide_${version}_Windows_64bit.exe"
wget ${download_url}
7z a -v50m "arduino-ide_${version}_Windows_64bit.7z" ${file_name}
rm -rf *.exe
mv arduino-ide_* ../arduino_ide/
find ../arduino_ide/ -type f | grep -v DS_Store | grep -v checksums.md5 | sort | xargs md5 -r > ../arduino_ide/checksums.md5