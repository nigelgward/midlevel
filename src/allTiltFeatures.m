%% Nigel Ward, January 2023

function [st, tiltRange, tf, tm, tn] = allTiltFeatures( ...
      perFrameTilts, isSpeakingVec, msPerWindow)

  prunedTilts = perFrameTilts;
  prunedTilts(isSpeakingVec == 0) = 0;
  
  frPerWindow = msPerWindow / 10;
  st = meansOverNonzeros(prunedTilts, isSpeakingVec, frPerWindow)
  
  %% prepare to get filterband counts per window
  nonzeroTilts = prunedTilts(prunedTilts~=0)
  [bincounts, binedges] = histcounts(nonzeroTilts, 100);
  cumPerc = cumsum(bincounts * 1.0 / sum(bincounts));
  veryNegThreshold       = ftfp(bincounts, binedges, cumPerc, .20)
  nearlyFlatThreshold    = ftfp(bincounts, binedges, cumPerc, .50)
  ninetyEighthPercentile = ftfp(bincounts, binedges, cumPerc, .98)
  
  nearlyFlatFrames = prunedTilts < 0  & ...  
  		     prunedTilts <= ninetyEighthPercentile & ...
		     prunedTilts > nearlyFlatThreshold
  middlingNegFrames = ...     
  		  prunedTilts <= nearlyFlatThreshold & ...
		  prunedTilts > veryNegThreshold
  %% only this one is non-boolean
  veryNegFrames = prunedTilts;
  veryNegFrames(veryNegFrames > veryNegThreshold) = 0

  tf = meansOverNonzeros(nearlyFlatFrames,  isSpeakingVec, frPerWindow);
  tm = meansOverNonzeros(middlingNegFrames, isSpeakingVec, frPerWindow);
  tn = .2 - meansOverNonzeros(veryNegFrames,isSpeakingVec, frPerWindow);

  for i = 1:length(perFrameTilts)
     tiltRange(i) = max(prunedTilts(i:i+frPerWindow)) - ...
		    min(prunedTilts(i:i+frPerWindow));
  end
end




%% findThresholdForPercentile
function threshold = ftfp(bincounts, binedges, cumPerc, targetPercentile)
[ignore, thresholdBin] = min(abs(cumPerc - targetPercentile));
threshold = binedges(thresholdBin);
end

%% to test
%%  [s1, s2, s3, s4, s5] = allTiltFeatures([9 8 7 1 2 3 9 6 6], [1 0 0 1 1 1 0 1 0], 10)
%%  [s1, s2, s3, s4, s5] = allTiltFeatures([-.1 +.1 -.2 -.3 -.1 -.7 -.3 -3 -.2], [1 1 1 1 1 1 1  0 1], 10)
