function allMeans = popstatsSliced(tlfile, featuresetSpec)

% Nigel Ward, UTEP, August 2015

% derived from popstats.m; see documentation there 

% modified to compute the means, not over entire files, 
%  but over 60-second pieces, in an attempt to get significance

load rotationspec   % get nmeans, nstds, and coeff, written by findDimensions.m
featurelist = getfeaturespec(featuresetSpec);

tracklist = gettracklist(tlfile);

meansInitialized = false;

for filenum = 1:length(tracklist)
  trackspec = tracklist{filenum};
  provenance = sprintf(...
      'generated from %s of %s , using features %s and rotation %s at %s', ...
      trackspec.side,  trackspec.filename, ...
      featuresetSpec, rotation_provenance, datestr(clock));
   rotated = normrotoneAblations(trackspec, featurelist, ...
				 nmeans, nstds, coeff, provenance, '/tmp');
   sliceSize = 3000;  % 30 seconds, 10 samples per sec (formerly 6000)
   nslices = length(rotated) / sliceSize;
   for slice = 0:(nslices - 1)
     sliceStart = 1 + sliceSize * slice;
     sliceEnd =       sliceSize * (slice + 1);
     newmeans = mean(rotated(sliceStart:sliceEnd,:));
     if meansInitialized
       allMeans = vertcat(allMeans, newmeans);
     else 
       allMeans = newmeans;
       meansInitialized = true;
     end %slice
   end %filenum 
end
