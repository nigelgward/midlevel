#!/bin/bash
# cd to directory where the sph files are,
#   e.g. discx/data, or istyles/testaudio
# then mkdir ../f0reaper
# run this with bash sph-to-splittrack-wav.bash
# will write f0 files to the ../f0reaper directory 
for infile in $(ls sw02[0123]*sph)  #  *sph (TEMPORARY change, to redo files skipped before)
do
    echo "${infile%%.*}".wav
    echo nice sox $infile -r 16000 -b 16 ../wavfiles/"${infile%%.*}"-l.wav remix 1
    nice sox $infile -r 16000 -b 16 -e signed ../wavfiles/"${infile%%.*}"-l.wav remix 1
    echo nice sox $infile -r 16000 -b 16 ../wavfiles/"${infile%%.*}"-r.wav remix 2
    nice sox $infile -r 16000 -b 16 -e signed ../wavfiles/"${infile%%.*}"-r.wav remix 2
    echo d:/nigel/istyles/reaper/REAPER/build/reaper.exe -i ../wavfiles/"${infile%%.*}"-l.wav -f ../f0reaper/"${infile%%.*}"-l-f0.txt -m 80 -x 500 -a -e 0.01
    nice d:/nigel/istyles/reaper/REAPER/build/reaper.exe -i ../wavfiles/"${infile%%.*}"-l.wav -f ../f0reaper/"${infile%%.*}"-l-f0.txt -m 80 -x 500 -a -e 0.01
    echo d:/nigel/istyles/reaper/REAPER/build/reaper.exe -i ../wavfiles/"${infile%%.*}"-r.wav -f ../f0reaper/"${infile%%.*}"-r-f0.txt -m 80 -x 500 -a -e 0.01
    nice d:/nigel/istyles/reaper/REAPER/build/reaper.exe -i ../wavfiles/"${infile%%.*}"-r.wav -f ../f0reaper/"${infile%%.*}"-r-f0.txt -m 80 -x 500 -a -e 0.01

    rm ../wavfiles/"${infile%%.*}"-r.wav
    rm ../wavfiles/"${infile%%.*}"-l.wav
    
done

    
