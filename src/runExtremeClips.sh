# pretty dumb, but better than running this 12 times by hand
#
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim01.txt > dim01.sh
 bash dim01.sh
 mv d1* dim01-clips
 #
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim02.txt > dim02.sh
 bash dim02.sh
 mv d2* dim02-clips
#
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim03.txt > dim03.sh
 bash dim03.sh
 mv d3* dim03-clips
#
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim04.txt > dim04.sh
 bash dim04.sh
 mv d4* dim04-clips
#
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim05.txt > dim05.sh
 bash dim05.sh
 mv d5* dim05-clips
#
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim06.txt > dim06.sh
 bash dim06.sh
 mv d6* dim06-clips
 #
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim07.txt > dim07.sh
 bash dim07.sh
 mv d7* dim07-clips
 #
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim08.txt > dim08.sh
 bash dim08.sh
 mv d8* dim08-clips
 #
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim09.txt > dim09.sh
 bash dim09.sh
 mv d9* dim09-clips
 #
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim10.txt > dim10.sh
 bash dim10.sh
 mv d10* dim10-clips
 #
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim1.txt > dim11.sh
 bash dim11.sh
 mv d11* dim11-clips
 #
 gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim12.txt > dim12.sh
 bash dim12.sh
 mv d12* dim12-clips
 
