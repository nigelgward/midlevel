% seekPredictors.m,    in nigel/comparisons/soudan/
% 
% January 2016, Nigel Ward, UTEP and Kyoto U

% run in directory c:/nigel/comparisons/soudan/

  % run in ../../comparisons/soudan
  % currently parseSoudan returns onsets for only one file
  % which is okay for now, since soundan1.tl lists only one file

% backchannel version
function seekPredictors()
  displayDifferences(parseSoudan('s4-left.txt'), ...
		     gettracklist('soudan4.tl'), ...
		     'wide.fss', ...
		     'Pre-Backchannel Averages (of z-normalized features)');
end

%         	     '../../ppca/sliptest/toneslip.fss', ...
		  %   'earlyPredictors.fss', ...

% fillers version.  Also need to go into parseSoudan and edit to use isFiller
%function seekPredictors()
%  displayDifferences(parseSoudan('one-l.txt'), ...
%	     gettracklist('soudan1.tl'), ...
%	     '../../ppca/sliptest/toneslip.fss', ...
%             'Prosody around Filler Onsets: counselor above, student below');
%end


  
% This is to help identify features useful for prediction.
% Display differences between the feature values at the listed times
%  and the feature values at other times
function displayDifferences(times, tracklist, featurespecfile, title)

  featurelist =  getfeaturespec(featurespecfile);
  monster = makeMultiTrackMonster(tracklist, featurelist);
  % normalize
  for col=1:length(featurelist)
    nmeans(col) = mean(monster(:,col));
    nstds(col) = std(monster(:,col));
    normalizedMonster(:,col) = (monster(:,col) - nmeans(col)) / nstds(col);
  end

  interestingFrames = floor(times * 100);

  % for backchannel onsets, actually ought to exclude not just such moments,
  % but everything within 500ms of one
  otherOnsetFrames = setdiff(1:length(monster), interestingFrames);

  interestingLines = normalizedMonster(interestingFrames,:);
  otherLines =  normalizedMonster(otherOnsetFrames,:);

  interestingMeans = mean(interestingLines);
  interestingStds = std(interestingLines);

  globalMeans = mean(otherLines); % will be close to zero, thanks to normalization
  globalStds = std(otherLines);   % will be close to one, ditto
  
  patvis2(title, 0.3 * interestingMeans, featurespecfile, makePlotspec(), ...
	  -10000, 10000);

  % report some t-tests
  for f = 1:length(featurelist)
     featurespec = featurelist(f);
     [h, p] = ttest(interestingLines(:, f), globalMeans(f));
     fprintf('feature %3d: %17s, mean = %5.2f, p-value=%.5f', ...
	     f, featurespec.abbrev, interestingMeans(f), p);
     if h == 1
       fprintf('*\n');
     else
       fprintf('\n');
     end
  end
end


function ps = makePlotspec()
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