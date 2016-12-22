function validateFeature()
%function validateFeature(featureFunction, aufile, annotationFile)

% Nigel Ward, December 2016
% compares the performance of featureFunction on aufile
% to the ideal hand-labeled feature presences, in annotationFile

% The annotation file is created by first labeling with elan,
%  then reformatting using tweakElanOutput.awk  

  % csv produced with tweakElanOutput.awk; see instructions there
  annotationFile = '../flowtest/21d-lengthening.csv';  
  %trackspec = makeTrackspec('l', 'prefix21d.au', '../flowtest/');
  %trackspec = makeTrackspec('l', 'prefix21d-10.au', '../flowtest/');
  trackspec = makeTrackspec('l', '21d.au', '../flowtest/');
  
  featureList(1) = makeFeatureSpec('le', 0, 200, 200, 'self', 0);
  featureList(2) = makeFeatureSpec('le', 0, 200, 200, 'inte', 0);
  featureList(3) = makeFeatureSpec('sr', 0, 200, 200, 'self', 0);
  featureList(4) = makeFeatureSpec('sr', 0, 200, 200, 'inte', 0);
  featureList(5) = makeFeatureSpec('vo', 0,  10,  10, 'self', 0);
 
  [~, vecset] = makeTrackMonster(trackspec, featureList);
  leftLE = vecset(:,1);
  rightLE = vecset(:,2);

  nframes = size(vecset,1);
  data = csvread(annotationFile);
  leftLenghteningTarget  = createTargets(1, data, nframes);
  rightLenghteningTarget = createTargets(2, data, nframes);
  leftFastTarget = createTargets(3, data, nframes);
  rightFastTarget = createTargets(4, data, nframes);

  compareVals(leftLE, .06, leftLenghteningTarget,  'Left: le for lengthening');
  compareVals(rightLE, .06, rightLenghteningTarget, 'Right: le for lenthening');

  compareVals(vecset(:,3), .22, leftFastTarget, 'Left:     sr for fast');
  compareVals(vecset(:,4), .22, rightFastTarget,'Right:    sr for fast');
  lengthToPlot = length(leftLenghteningTarget);
  xaxis = 1:lengthToPlot;
  plot(xaxis,leftLenghteningTarget,  xaxis, 4 * vecset(1:lengthToPlot,1));
  legend('target', 'predicted');

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


% given lables, returns a vector of per-frame targets
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


function fs = makeFeatureSpec(code, startms, endms, duration, side, color)
  fs.featname = code;
  fs.startms = startms;
  fs.endms = endms;
  fs.duration = duration;
  fs.side = side;
  fs.plotcolor = color;
end


function trackspec = makeTrackspec(side, filename, directory)
  trackspec.side = side;
  trackspec.filename = filename;
  trackspec.directory = directory;
  trackspec.path = [directory filename];
end
