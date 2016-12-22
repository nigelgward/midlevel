# tweakElanOutput.awk
#
# Nigel Ward, December 2016
#
# awk -f tweakElanOutput.awk ../flowtest/21d-lengthening.txt 
#    > 21d-lenghtening.csv
#
# this code converts elan's output
#  (as written using export -> tab-delimited)
#  into something that matlab can read easily

# The elan output format contains 4 things we care about:
# the "tier label", the 1st field 
# the start time (ms), the 4th field
# the end time (ms), the 7nd field 
# the label, the 11th field 

# For now, the only labels we care about are left-lengthening,
#  which gets translated to 1
# and right-lenghening, which gets translated to 2

# the output format is 
#  track, startms, endms, label
# where track is 1 for left and 2 for right 

{

}
