% for small-scale testing
% more commonly, featurespecs will be read from a file, with getfeaturespec.m
%
function fs = makeFeatureSpec(code, startms, endms, side, color)
  fs.featname = code;
  fs.startms = startms;
  fs.endms = endms;
  fs.duration =  endms - startms;
  fs.side = side;
  fs.plotcolor = color;
end
