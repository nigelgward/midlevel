%% Nigel Ward, January 2023
%% see comments below the code

function [st, tiltRange, tf, tm, tn] = allTiltFeatures( ...
      perFrameTilts, logEnergy, msPerWindow)
  isSpeakingVec = speakingFrames(logEnergy);
  if size(isSpeakingVec,2) ~=  size(perFrameTilts,2)
    %%fprintf('allTiltFeatures: warning  size mismatch: iSV %d %d vs pFT %d %d ', ...
    %%   size(isSpeakingVec), size(perFrameTilts));
    lengthDifference = size(perFrameTilts,2) - size(isSpeakingVec,2);
    switch lengthDifference
      case -2
	perFrameTilts = [0 perFrameTilts 0];
      case -1
	perFrameTilts = [perFrameTilts 0];
      case 0
	error('bug')
      case 1
	perFrameTilts = perFrameTilts(1:end-1);
      case 2
	perFrameTilts = perFrameTilts(2:end-1);
      otherwise
	error('lengths badly differ');
    end
  end
  
  frPerWindow = msPerWindow / 10;
  globalMeanOfValids = mean(perFrameTilts(isSpeakingVec==true));
  st = meansOverNonzeros(perFrameTilts, isSpeakingVec, frPerWindow,globalMeanOfValids);

  prunedTilts = perFrameTilts;
  prunedTilts(isSpeakingVec == 0) = 0;
  nonzeroTilts = prunedTilts(prunedTilts~=0);
  [bincounts, binedges] = histcounts(nonzeroTilts, 100);
  cumPerc = cumsum(bincounts * 1.0 / sum(bincounts));
  veryNegThreshold       = ftfp(bincounts, binedges, cumPerc, .20);
  nearlyFlatThreshold    = ftfp(bincounts, binedges, cumPerc, .50);
  ninetyEighthPercentile = ftfp(bincounts, binedges, cumPerc, .98);
  
  %% the first two are boolean; but veryNegFrames is scalar
  nearlyFlatFrames = prunedTilts < 0  & ...  
  		     prunedTilts <= ninetyEighthPercentile & ...
		     prunedTilts > nearlyFlatThreshold;
  middlingNegFrames = ...     
  		  prunedTilts <= nearlyFlatThreshold & ...
		  prunedTilts > veryNegThreshold;
  veryNegFrames = prunedTilts;
  veryNegFrames(veryNegFrames > veryNegThreshold) = 0; % not negative enough

  tf = meansOverNonzeros(nearlyFlatFrames,  isSpeakingVec, frPerWindow, 0);
  tm = meansOverNonzeros(middlingNegFrames, isSpeakingVec, frPerWindow, 0);
  tn = - meansOverNonzeros(veryNegFrames,   isSpeakingVec, frPerWindow, 0);

  for firstFrame = 1:length(perFrameTilts)
    lastFrame = min(firstFrame + frPerWindow - 1, length(perFrameTilts));
    tiltRange(firstFrame) = max(prunedTilts(firstFrame:lastFrame)) -  ...
			    min(prunedTilts(firstFrame:lastFrame));
  end
end


%% findThresholdForPercentile
function threshold = ftfp(bincounts, binedges, cumPerc, targetPercentile)
[ignore, thresholdBin] = min(abs(cumPerc - targetPercentile));
threshold = binedges(thresholdBin);
end

%% to test
%%  [s1, s2, s3, s4, s5] = allTiltFeatures([9 8 7 1 2 3 9 6 6], [1 0 0 1 1 1 0 1 0], 10)
%%  [st, tr, tf, tm, tn] = allTiltFeatures([-.1 +.1 -.2 -.3 -.1 -.8 -.3 -3 -.2 -.1 -.1], [1 1 1 1 1 1 1  0 1 1 1], 10)

%% Midlevel Tilt-Based Features: Design Notes
%% 
%% Jan 22, 2023, Nigel Ward
%% 
%% The aim of this research memo is to document thoughts on new midlevel
%% features based on spectral tilt.
%% 
%% By plotting the raw spectral tilt values, frame-by-frame, it's clear
%% that they are exceedingly noisy.  We expect spectral tilt to depend
%% primarily on the phoneme: most positive for fricatives, most negative
%% for vowels, but examination indicates that even within one phoneme the
%% tilt can vary greatly.
%% 
%% So we need to aggregate it into something more stable.  In general,
%% perception-related prosodic features seem to be at least 50-100 ms
%% wide, so anything at narrower spans is not needed.
%% 
%% For most prosodic features the mean seems the most obvious candidate
%% for aggregation; at least for pitch and intensity.  However previous
%% research suggests that range may be more informative, at least for
%% predicting hyperarticulation.
%% 
%% The distribution of spectral tilt values appears to never have been
%% discussed in the literature.  In our data, it is usually zero at
%% moments of silence, generally slightly negative, occasionally very
%% negative, and very occasionally positive.  Is it appropriate to take
%% the mean?  
%% 
%% Listening to a few samples of timepoints in each of the three
%% categories, suggests no. Both positive and very negative tilts often
%% occur in utterances that seem emphatic, perhaps in different ways.
%% Additionally the points with very shallow negative slope seem
%% generally conversationally unimportant, while points with moderate,
%% average-ish negative slope seem like normal conversation.  All of
%% these, especially the last, are based on very few observations.  But
%% it already seems clear that by taking the average we'd lose 
%% information, at least for significantly positive points. 
%% 
%% It also looks like the distributions vary with the speaker.  We don't
%% know if this is because speakers differ in typical tilt ranges, and
%% only variation from their typical matters, or whether the meanings of
%% different levels of tilt have absolute, cross-speaker meanings. For
%% now we'll assume the former, and normalize everything to the speaker's
%% distribution as computed over each track processed, using the
%% percentile trick, as done for pitch.
%% 
%% Anyway, given that average would be a mistake, what to do?
%% 
%% 1) First we can compute the overall Tilt Range, as a measure likely to
%% correlate with emphasis and articulation.  And in addition we'd like
%% to compute the propensity of tilt to be in various ranges.
%% Positive-tilt points are so few, perhaps 1 per minute, that an
%% explicit feature for them wouldn't do us much good. Their contribution
%% instead will just be in their effects on the tilt range.  This range
%% feature could be expressed in the difference in percentiles between
%% the highest point in the window and the lowest one.
%% 
%% 2) Second, we want to catch those Very Negative points.  It seems
%% likely that more negative slopes are more extreme (strongly
%% emphasized, perhaps) and if so, our Very Negative feature should count
%% those more strongly.  Let's say that every point below the 20th
%% percentile pitch counts to this according to how far it is below that
%% threshold.  That is, a 19th percentile tilt point would contribute 1
%% to this feature, and a 2nd percentile point would contribute 18.
%% Should we subsequently z-normalize this for each track? Probably not.
%% 
%% 3) Third, we need a Nearly Flat feature.  It's possible this will
%% correlate hugely with low intensity, but if so, we'll find that out.
%% This might might be a fixed range, but, prefering to keep things in
%% percentiles, this could be from the 75th to the 98th percentile,
%% evenly weighted.  The 98th percentile would avoid including positive
%% pitch points, since they are rare, and probably also many points
%% infinitesimally close to zero.
%% 
%% 4) Fourth, we need a Middling Negative feature.  For tidiness, this
%% could cover all remaining points, that is, those from the 20th to 75th
%% percentile.  
%% 
%% In general, a bank of trapezoidal filters is prefereable.  Here the
%% Very Negative is triangular, and the Nearly Flat and Middling Negative
%% are rectangular for the sake of implementation simplicity and
%% efficiency.   This could be revisited later. 
%% 
%% Note that these 4 features will all have only ever 0-or-positive
%% values, and be far from normally distributed.


%% some observations on correlations with other features:
%% negative tilt correlates with high cpps, or low breathiness ... odd
%%  high spectral tilt correlates with reduction and lengthening ... odd
%% high tilt range correlates with lots of very negative tilts, obviously
%%   and high volume, and high pitch, and low overall tilt
%% tilt flattish correlates with low pitch, and high voicing fraction,
%%   and vew very negative tilts
%% tilt middling correlates with pitch, both narrow and wide, and high volume
%% tilt very negative correlates with wide tilt range,
%%   and enunciation, odddly, and high pitch, and negative overall tilt, of course
