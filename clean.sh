#!/bin/sh

#rm -fr $(find . -type f | grep '?' | sed 's:^.::' | grep -i cmake)
rm -f cmake_install.cmake Makefile CMakeCache.txt
rm -fr CMakeFiles
echo "[+] Cleaning files generated by cmake"

rm -fr build/
rm -fr include/
rm -fr lib/
#find . -name "Makefile" | xargs rm 2> /dev/null
echo "[+] Cleaning files generated by make"