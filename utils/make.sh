#!/bin/sh

# binutils
find binutils* -name '*.1' | xargs basename -s .1 > ../data/binutils

# coreutils
ls coreutils/man/*.x | xargs basename -s .x > ../data/coreutils

# diffutils
ls diffutils/man/*.x | xargs basename -s .x > ../data/diffutils

# findutils
find findutils -name '*.1' | xargs basename -s .1 > ../data/findutils

# fontutils
grep -A 1 'programs = ' fontutils*/GNUmakefile | perl -lne 'print join "\n", grep { $_ ne "programs" and m/[a-z]/ } split' > ../data/fontutils

# idutils
cp idutils/idutils.txt ../data/idutils

# inetutils
ls inetutils/man/*.h2m | xargs basename -s .h2m > ../data/inetutils

# mailutils
ls mailutils/doc/man/*.1 | xargs basename -s .1 > ../data/mailutils

# paxutils
echo rmt > ../data/paxutils

# plotutils
ls plotutils*/info/*.1 | xargs basename -s .1 > ../data/plotutils

# recutils
ls recutils/man/*.1 | xargs basename -s .1 > ../data/recutils

# sharutils
grep  ^bin_PROGRAMS sharutils/src/Makefile.am  | perl -lne 'print join "\n", m/=\s+([^\s]+)\s+([^\s]+)/' > ../data/sharutils

# termutils
grep ^PROGRAMS termutils*/Makefile | perl -lne 'print join "\n", grep { /[a-z]/ } split' > ../data/termutils

# sysutils
ls sysutils/man/*.{1,8} | xargs basename -s .1  | xargs basename -s .8 > ../data/sysutils

cd ../data
for i in *
do
  ruby -r json -e 'BEGIN{p=[];}; while gets; p << [ $_.chomp, "'$i'" ]; end; puts JSON.generate(p);' < $i > $i.json
done

echo -n 'var data =' > data.js
cat *.json | jq -c -M --slurp [.[][]] >> data.js
