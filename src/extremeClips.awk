
# extremeClips.awk, in midlevel/src
# use an "extremes" file to create clips for each extreme
# Nigel Ward, UTEP and SDU, June 2025
# example:
#               where xxx is the directory with the wavfiles
#               and yyy is the midlevel/src directory
#    cd xxx  
#    mkdir dim01-clips
#    gawk -f yyy/extremeClips.awk extremes/dim01.txt > dim01.sh
#    bash dim01.sh     # expect a few warnings about "end of audio": ignore
#    mv d01* dim01-clips
#  and do this for any dimension of interest

BEGIN{ scanningLeft = 0}
{
    if (match($0, "generated from l"))
	{scanningLeft = 1}
    if (match($0, "generated from r"))
       {scanningLeft = 0}
    # otherwise scanningLeft is unchanged
    if (!scanningLeft)
	next
    dim = $1
    if (!dim == dim+0 && dim > 0) # if not a number, skip to next input line
      {next}
    value = $2
    timepoint = $4
    start = timepoint - 2.5  # seconds
    duration = 5.0   # seconds
    if ($5 == "(")     # a stray paren 
       {timeString = $6;
	wavFile = $8}
    else
       {timeString = $5
	wavFile = $7}

    sub(/)/, "", timeString)
    sub(/\(/, "", timeString)
    sub(/:/, "m", timeString)  # separate minutes and seconds
  
    wavFileBase = substr(wavFile, 1, length(wavFile)-4)

    valueString = sprintf("%+.2f", value)
    eFileName = "d" dim "-" wavFileBase valueString "-" timeString ".wav"
    eFileNameLeft  = "d" dim "-" wavFileBase valueString "-" timeString "-l.wav"
    eFileNameRight = "d" dim "-" wavFileBase valueString "-" timeString "-r.wav"	
    cmd      = "sox " wavFile " " eFileName " trim " start " 5"
    cmdLeft  = "sox " wavFile " " eFileNameLeft  " trim " start " 5 remix 1"
    cmdRight = "sox " wavFile " " eFileNameRight " trim " start " 5 remix 2"
    
    print cmd
    print cmdLeft
    print cmdRight
}

## execute these in pca-redu-only/
#   mkdir dim01-clips
#   mkdir dim02-clips
#   mkdir dim03-clips
#   mkdir dim04-clips
#   mkdir dim05-clips
#   mkdir dim06-clips
#   mkdir dim07-clips
#   mkdir dim08-clips
#   mkdir dim09-clips
#   mkdir dim10-clips
#   mkdir dim11-clips
#   mkdir dim12-clips
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim01.txt > dim01.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim02.txt > dim02.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim03.txt > dim03.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim04.txt > dim04.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim05.txt > dim05.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim06.txt > dim06.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim07.txt > dim07.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim08.txt > dim08.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim09.txt > dim09.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim10.txt > dim10.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim11.txt > dim11.sh
#   gawk -f ../ml2/midlevel/src/extremeClips.awk extremes/dim12.txt > dim12.sh
#   bash dim01.sh     # expect a few warnings about "end of audio": ignore
#   bash dim02.sh     # expect a few warnings about "end of audio": ignore
#   bash dim03.sh     # expect a few warnings about "end of audio": ignore
#   bash dim04.sh     # expect a few warnings about "end of audio": ignore
#   bash dim05.sh     # expect a few warnings about "end of audio": ignore
#   bash dim06.sh     # expect a few warnings about "end of audio": ignore
#   bash dim07.sh     # expect a few warnings about "end of audio": ignore
#   bash dim08.sh     # expect a few warnings about "end of audio": ignore
#   bash dim09.sh     # expect a few warnings about "end of audio": ignore
#   bash dim10.sh     # expect a few warnings about "end of audio": ignore
#   bash dim11.sh     # expect a few warnings about "end of audio": ignore
#   bash dim12.sh     # expect a few warnings about "end of audio": ignore
#   mv d01* dim01-clips
#   mv d02* dim02-clips
#   mv d03* dim03-clips
#   mv d04* dim04-clips
#   mv d05* dim05-clips
#   mv d06* dim06-clips
#   mv d07* dim07-clips
#   mv d08* dim08-clips
#   mv d09* dim09-clips
#   mv d10* dim10-clips
#   mv d11* dim11-clips
#   mv d12* dim12-clips

