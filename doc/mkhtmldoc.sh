#!/bin/sh
mkdir -p html/VLC/Transport
mkdir -p html/VLC/Helper/Stream/Access
mkdir -p html/VLC/Helper/Stream/Mux
find ../lib -type f | grep -v -e svn | sed -e 's/\(.*\)/pod2html --infile=\1 \1/' -e 's/m \.\.\/lib/m --outfile=html/' -e 's/pm$/html/' | /bin/sh -
rm *tmp