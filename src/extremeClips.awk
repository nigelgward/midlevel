
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

