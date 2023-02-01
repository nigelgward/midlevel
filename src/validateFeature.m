function vecset =  validateFeature()

%% Nigel Ward, December 2016, Jan 2023
%% Used as a driver for small-scale testing
  
%% One use was to compare the performance of a feature dectector on aufile
%%  to the ideal hand-labeled feature presences, in annotationFile, 
%%  where the annotation file was created by first labeling with elan,
%%  then reformatting into csv using tweakElanOutput.awk  

  annotationFile = '../flowtest/21d-lengthening.csv';  
  %%trackspec = makeTrackspec('l', 'prefix21d.au', '../flowtest/');
  %%trackspec = makeTrackspec('l', '10sec-21d.au', '../flowtest/');
  %%trackspec = makeTrackspec('l', '30sec-21d.au', '../flowtest/');
  %%trackspec = makeTrackspec('l', 'second10s-21d.au', '../flowtest/');
  %%trackspec = makeTrackspec('l', 'ten-twelve-21d.au', '../flowtest/');
  trackspec = makeTrackspec('l', '21d.au', '../flowtest/');
  trackspec = makeTrackspec('l', 'dral-es_001.wav', '../../research/reduction/');
  trackspec = makeTrackspec('l', 'ES_001-downsampled.wav', '../../research/reduction/');
%  trackspec = makeTrackspec('l', 'prefix-21d.wav', '../flowtest/');
%  trackspec = makeTrackspec('r', 'utep04.au', 'f:/comparisons/en-social/');

  featureList(1) = makeFeatureSpec('st',  -10,  10, 'self', 0);
  featureList(2) = makeFeatureSpec('tr',  -50,  50, 'self', 0);
  featureList(3) = makeFeatureSpec('tf',  -50,  50, 'self', 0);
  featureList(4) = makeFeatureSpec('tm',  -50,  50, 'self', 0);
  featureList(5) = makeFeatureSpec('tn',  -50,  50, 'self', 0);
  
  featureList(6) = makeFeatureSpec('vo',    0,  10, 'self', 0);
  featureList(7) = makeFeatureSpec('vf', -100, 100, 'self', 0);
  featureList(8) = makeFeatureSpec('sf', -100, 100, 'self', 0);
  featureList(9) = makeFeatureSpec('en', -150, 150, 'self', 0);
  featureList(10) = makeFeatureSpec('re', -150, 150, 'self', 0);
  featureList(11)= makeFeatureSpec('cp', -200, 200, 'self', 0);
 
tic
  [~, vecset] = makeTrackMonster(trackspec, featureList);
toc
  featureOfInterest = vecset(:,1);
  figure(96)
  hold on 
  plot(1000*vecset(:,1), 'k');  % mean 
%  plot(1000*vecset(:,2), 'r');  % range
%  plot(vecset(:,3), 'b');       % flattish 
%  plot(vecset(:,4), 'g');       % middling
  plot(1000*vecset(:,5), 'c');       % negative    !! broken
%  plot(vecset(:,6), 'm'); 
return 

  leftLE = vecset(:,1);
  rightLE = vecset(:,2);

  nframes = size(vecset,1);


  data = csvread(annotationFile);
  leftLengtheningTarget  = createTargets(1, data, nframes);
  rightLengtheningTarget = createTargets(2, data, nframes);
  leftFastTarget = createTargets(3, data, nframes);
  rightFastTarget = createTargets(4, data, nframes);

  compareVals(leftLE, .06, leftLengtheningTarget,  'Left: le for lengthening');
  compareVals(rightLE, .06, rightLengtheningTarget, 'Right: le for lenthening');

  compareVals(vecset(:,3), .22, leftFastTarget, 'Left:     sr for fast');
  compareVals(vecset(:,4), .22, rightFastTarget,'Right:    sr for fast');

  %smallplot(vecset(:,5), vecset(:,8), vecset(:,9));
  legend('volume', 'enunciation', 'reduction');

  corr = corrcoef(vecset(:,1), vecset(:,3));
  fprintf('correlation between le and sr on left is %.2f\n', corr(1,2));
  corr = corrcoef(vecset(:,2), vecset(:,4));
  fprintf('correlation between le and sr on right is %.2f\n', corr(1,2));
end

% Our aim is a continous measure of lengthening
%   so we could eval by correlations with the target values
% But most of the target values are zero, esp. in regions of silence
%  so instead evaluate by the numbers of frames correctly predicted as lengthened
function compareVals(prediction, threshold, target, title)
  hits    = (prediction > threshold)  & (target > 0);
  misses  = (prediction <= threshold) & (target > 0);
  falarms = (prediction > threshold)  & (target <= 0);
				%printErrorTimes(misses, falarms);
  coverage = sum(hits) / (sum(hits) + sum(misses));
  accuracy = sum(hits) / (sum(hits) + sum(falarms));
  fprintf('%s: coverage, %.2f accuracy %.2f, F %.2f \n', ...
	  title, coverage, accuracy, 2 * coverage * accuracy / (coverage + accuracy));
end

% in practice it's more useful to look at plots of targets vs false alarms 
function printErrorTimes(misses, falarms)
  missRegionStarts    = misses(2:end)  - misses(1:end-1);
  falarmRegionStarts = falarms(2:end) - falarms(1:end-1);
  for i = 1:length(missRegionStarts)
    if missRegionStarts(i) == 1
      fprintf('missed lengthening starting at %.2f seconds\n', i / 100.);
    end
    if falarmRegionStarts(i) == 1
      fprintf('lengthening falsely detected starting at %.2f seconds\n', i / 100);
    end
  end
end


% given labels, returns a vector of per-frame targets
function vec = createTargets(track, annotations, nframes)
  msPerFrame = 10;
  vec = zeros(nframes,1);
  indices = annotations(:,1) == track;
  relevantRows = annotations(indices,:);
  for row = 1:min(nframes, size(relevantRows,1))
    startms = relevantRows(row, 2);
    endms = relevantRows(row, 3);
    label = relevantRows(row, 4);
    startFrame = floor(startms / msPerFrame);
    endFrame = floor(endms / msPerFrame);
    for frame = startFrame:endFrame
      if frame <= nframes
	vec(frame) = label;
      end
    end
  end
end


function smallplot(vec1, vec2, vec3)
  clf
  hold on 
  lengthToPlot = 200;
  lengthToPlot = length(vec1);
  xaxis = 1:lengthToPlot;
  plot(xaxis, vec1, xaxis, vec2 + 3, xaxis, vec3 + 6);
  set(gca, 'XTick', 0:200:length(vec1));
end
