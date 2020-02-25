% Input is distance, output is nearness
% Distance is in arbitrary units.
% When distance is close to 0, nearness is close to 1
% When distance is large, nearness approaches zero
% This has not been tested in actual use. 
function nearnessVec = distanceToNearness(distanceVec)
  nearnessVec = 1.0 ./ (log(.0001 + distanceVec));
