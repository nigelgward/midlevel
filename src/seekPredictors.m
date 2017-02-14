% seekPredictors.m   in h:/nigel/comparisons/jp-toyota/src/
% January 2016, Nigel Ward, UTEP and Kyoto U

% Creates a graph showing typical prosodic-feature values
%  before some events of interests
%  And some stats suggestind whether those are likely good predictors
% The main function is displayDifferences() below;
% It's called by the driver function seekPredictors(),
%  which will need to be edited for any specific experiment.

% run in comparisons/jp-toyota/july2016/
function seekPredictors()
  [targetTimestamps, targets] = readTargets('evaluation_label_f01.csv');
  nowTurnstatusVec = targets(:,1);  % 0 is silence, 1 BC, 2 filler, 3  full turn
  nextTurnstatusVec = targets(:,2);
  turnStartVec = nowTurnstatusVec < 2 & nextTurnstatusVec >=2;
  turnStartTimes = targetTimestamps(find(turnStartVec==1));
  fprintf('analyzing over %d turnstarts, %d other points\n', ...
	  length(turnStartTimes), length(nowTurnstatusVec) - length(turnStartTimes));
  displayDifferences(.001 * turnStartTimes, ...
		     gettracklist('../single.tl'), ...
		     '../../../midlevel/flowtest/slim2.fss', ...
		     'Averages (of z-normalized features) around turn starts');
end

  % run in directory c:/nigel/comparisons/soudan/
  % currently parseSoudan returns onsets for only one file
  % which is okay for now, since soundan1.tl lists only one file
  % backchannel version
  %function seekPredictors()
  %  displayDifferences(parseSoudan('s4-left.txt'), ...
  %		     gettracklist('soudan4.tl'), ...
  %		     'wide.fss', ...
  %		     'Pre-Backchannel Averages (of z-normalized features)');
  % end

% Display differences between the feature values at the listed times
%  and the feature values at other times (the "control set")
% This is to help identify features useful for prediction.
% Inputs
%  times = timepoints of interest, in seconds
%  tracklist = specifies just one track 
%  featurespecfile = features to use 
%  title = title of plot
% In future, might want to exclude points within 500ms of a listed time
%  from the control set.
% In future, might want to compare two sets of timepoints: aTimes, and bTimes
function displayDifferences(times, tracklist, featurespecfile, title)
  interestingFrames = floor(times * 100);

% temporary, for testing, if only running on the first 10 seconds
%  interestingFrames = interestingFrames(1:6)   
%  fprintf('REMOVE PREVIOUS LINE FOR ACTUAL RUN!! REMOVE PREVIOUS LINE FOR ACTUAL RUN!!\n');

  if length(tracklist) > 1
    fprintf('!!!!!!!Warning: seekPredictors cannot yet handle multiple files\n');
  end 
  featurelist =  getfeaturespec(featurespecfile);
  monster = makeMultiTrackMonster(tracklist, featurelist);
  %fprintf('size(monster) is %d %d\n', size(monster));
  % z-normalize
  for col=1:length(featurelist)
    nmeans(col) = mean(monster(:,col));
    nstds(col) = std(monster(:,col));
    normalizedMonster(:,col) = (monster(:,col) - nmeans(col)) / nstds(col);
  end

  controlsetFrames = setdiff(1:length(monster), interestingFrames);

  interestingLines = normalizedMonster(interestingFrames,:);
  controlsetLines =  normalizedMonster(controlsetFrames,:);

  interestingMeans = mean(interestingLines);
  interestingStds = std(interestingLines);

  globalMeans = mean(controlsetLines); % will be close to zero, thanks to normalization
  globalStds = std(controlsetLines);   % will be close to one, ditto
  
  patvis2(title, 0.3 * interestingMeans, featurelist, midPlotspec2(0.7), -2500, 2500);

  % report some t-tests
  for f = 1:length(featurelist)
     featurespec = featurelist(f);
     [h, p] = ttest(interestingLines(:, f), globalMeans(f));
     fprintf('feature %3d: %20s, mean = %5.2f, p-value=%.5f', ...
	     f, featurespec.abbrev, interestingMeans(f), p);
     if h == 1
       fprintf('*\n');
     else
       fprintf('\n');
     end
  end
end


function ps = makePredictorsPlotspec()
  dustyPurple = [140/256 106/256 186/256];    
  darkGreen  = [127/256 190/256 92/256];     
  mexicanFlagRed = [206/256  17/256  38/256]; 
  mexicanFlagGreen = [  0/256 104/256 71/256];

  % side, feature type, label, ybaseline, ygain, color, linestyle
  % note that y = 0 is at the lower left
  ps =[{'self'}, {'vo'}, {'Volume'},     105, 10, dustyPurple, {'-'}; ...
       {'self'}, {'cr'}, {'Creakiness'},  95, 10, dustyPurple, {'-'}; ...
       {'self'}, {'sr'}, {'S. Rate'},     85, 10, dustyPurple, {'-'}; ...
       {'self'}, {'ph'}, {'Pitch Height'},75, 10, dustyPurple, {'-'}; ...
       {'self'}, {'pr'}, {'Pitch Range'}, 65, 10, dustyPurple, {'-'}; ...
       ...
       {'inte'}, {'vo'}, {'Volume'},      50, 10, darkGreen, {'-'}; ...
       {'inte'}, {'cr'}, {'Creakiness'},  40, 10, darkGreen, {'-'}; ...
       {'inte'}, {'sr'}, {'S. Rate'},     30, 10, darkGreen, {'-'}; ...
       {'inte'}, {'ph'}, {'Pitch Height'},20, 10, darkGreen, {'-'}; ...
       {'inte'}, {'pr'}, {'Pitch Range'}, 10, 10, darkGreen, {'-'}; ];
end
