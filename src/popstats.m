function allMeans = popstats(tlfile, featuresetSpec)

% Nigel Ward, UTEP, June 2015

% compute population statistics.  derived from applynormrot.m 

% Apply the pre-saved normalization-and-rotation to the specified files
% and for each, compute the mean on each dimension.
% return an array of PCA-value averages, where y = track and x = dimension number.

% Useful for subsequently comparing the means across populations.
% Using each speaker in a population as a separate trial.  
% (For the speakers who appear in multiple tracks, exclude latter tracks
%  from this test, since they're not independent trials)

% After doing this for two populations (two tracklists), 
% we do a t-test to compare, to find out for which dimensions,
% if any, the means are significantly different.
% Specifically,  do an unmatched, unequal-variance t-te, since the speakers are
%  not matched in any way, and indeed there are different numbers of
%  speakers in the conditions; and the variances are not equal.

% In particular, compare the non-natives to the natives. 

% Will do the t-test in excel, since matlab doesn't handle heteroscedastic .
%  so, need to write the results to a file 
%     csvwrite('natmeans.csv', natmeans)
%     csvwrite('nonmeans.csv', nonmeans)
% In excel, import the data for the natives, then below it the data for the non-natives

% Then for each vertical pair (each dimension), do a a heteroscedastic t-tests, 
% Note: use a Bonferroni correction of 16, the number of dimensions tried, which
%  means the effective confidence required will be 0.05 / 16 = 0.003125.
% The excel command is t.test(..., ..., 2, 3)

% To test: means = popstats('minitracklist.tl', 'minicrunch.fss')

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
   if meansInitialized
     allMeans = vertcat(allMeans, mean(rotated));
   else 
     allMeans = mean(rotated)
     meansInitialized = true;
   end
end
