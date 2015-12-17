# find-extremes.py, new version, in isg/speech/ppca/src
# Nigel Ward, August 2014

# Finds some of the extreme values on each dimension,
#  by examining all .pc files in the specified directory.
# Writes the results for each dimension as a text file listing timepoints,
#  in the extremes/ subdirectly of the specified directory

# First we find the 10 highest and lowest in each file
#  then we create a consolidated list

# This is useful for subsequent listening, for the sake of
# interpreting each dimension.

# note that .pc files have a one-line header, 
# then each line is the time, followed by one column per dimension

import os
import sys

if len(sys.argv) < 3:
   print "  format: python find-extremes.py dir num"
   print "  dir is the directory containing the .pc files"
   print "  num is how many dimensions to process (refer to the .fss file)"
   sys.exit(1)

pcdir = sys.argv[1] 
ndimensions = int(sys.argv[2])

workdir = '/tmp/extremes/'
tmpConHighs = workdir + 'consolidated-highs.txt'
tmpConLows  = workdir + "consolidated-lows.txt"
scratchfile = workdir + "scratchtmp"

outputdir = pcdir + "/extremes/"

if not os.path.exists(workdir):
    os.makedirs(workdir)
if os.listdir(workdir) != []:
    os.system("rm " + workdir + "*")

if not os.path.exists(outputdir):
    os.makedirs(outputdir)
if os.listdir(outputdir) != []:
    os.system("rm " + outputdir + "*")

for dim in range(1, ndimensions+1):   
    dimstr = str(dim)
    print 'Processing dimension' + dimstr
    conHighs = outputdir + "hi" + dimstr + ".txt"
    conLows  = outputdir + "lo" + dimstr + ".txt"

    for filename in os.listdir(pcdir):    # encodes au filename and track
      if not filename.endswith(".pc"):
        continue
      print ' Processing ' + filename
      # four temporary files
      lowfile = workdir + "tmp-" + filename + dimstr + '-lo' 
      highfile =workdir + "tmp-" + filename + dimstr + '-hi'
      lowfile2 = workdir + "tmp-" + filename + dimstr + '-lo2' 
      highfile2 =workdir + "tmp-" + filename + dimstr + '-hi2'
      # sort
      sortcmd = "awk \'{print \" \" $" + str(dim+1) + ", $1}\' "
      os.system(sortcmd + pcdir + "/" + filename + " | sort -n -k1 > " + scratchfile)
      # take the top 20 and lowest 20 and save them
      os.system("head -n 32 " + scratchfile + " > " + lowfile)
      os.system("tail -n 32 " + scratchfile + " > " + highfile)

      srcfile = filename[:-5]
      channel = filename[-4:-3]
      toappend = " " + srcfile + " " + channel 
      # at this point $0 will be the dimension's value followed by the timestamp
      # so prepend the dimension and postpend the aufilename and channel
      embelishcmd = "awk \'{print \"" + dimstr + " \" $0 \"" +  toappend + "\" }\' "
      os.system(embelishcmd + " " + lowfile + " > " + lowfile2)
      os.system(embelishcmd + " " + highfile + " > " + highfile2)

    # create a consolidated list
    sedpipe1 = " | sed 's/\/tmp\/extremes\///' "  # zap some junk
    sedpipe2 = sedpipe1 + " | sed 's/.pc//' "     # zap more junk
    sedpipe3 = sedpipe2 + " | sed 's/00 / /' "    # zap trailing zeros on timestamps
    
    os.system("cat " + workdir + "*lo2* >> " + tmpConLows)  
    os.system("cat " + workdir + "*hi2* >> " + tmpConHighs)
    os.system("sort -nr -k1 "  + tmpConHighs + sedpipe3 + " > " + conHighs)  
    os.system("sort -nr -k1 " + tmpConLows + " > " + conLows)   
    os.system("rm " + workdir + "tmp*")     # delete the per-file listings
    # now do the next dimension
print 'done'

