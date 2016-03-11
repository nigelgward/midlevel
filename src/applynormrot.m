function allRotated = applynormrot(tlfile, featuresetSpec, outdir)
%% Nigel Ward, UTEP, February 2015
%% Apply the pre-saved normalization-and-rotation to the specified files,
%% writing a .pc file for each

%% To test
%%   1. findDimensions.m('minitracklist.tl', 'minicrunch.fss');
%%   2. applynormrot('minitracklist.tl', 'minicrunch.fss', './');

load rotationspec   % get nmeans, nstds, and coeff, written by findDimensions.m
featurelist = getfeaturespec(featuresetSpec);
% clear statistics file, since we'll be appending to it; ok if this fails
% system('rm summary-stats.txt');   

tracklist = gettracklist(tlfile);

allRotatedInitialized = false;

extremesdir = [outdir '/extremes/'];
pcfilesdir = [outdir '/pcfiles/'];
if ~exist(extremesdir, 'dir')
  mkdir(extremesdir); 
end
if ~exist(pcfilesdir)
  mkdir(pcfilesdir);  
end

for filenum = 1:length(tracklist)
  trackspec = tracklist{filenum};
  provenance = sprintf(...
      'generated from %s of %s , using features %s and rotation %s at %s', ...
      trackspec.side,  trackspec.filename, ...
      featuresetSpec, rotation_provenance, datestr(clock));
   rotated = normrotoneAblations(trackspec, featurelist, ...
				 nmeans, nstds, coeff, provenance, ...
				 extremesdir, pcfilesdir);
   if allRotatedInitialized
     allRotated = vertcat(allRotated,rotated);
   else 
     allRotated = rotated;
     allRotatedInitialized = true;
   end
end
