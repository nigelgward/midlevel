function reconstruct(trackspec, featurelist, nmeans, nstds, coeff, ndims)
% ppca/src4/reconstruct.m
% Nigel Ward, University of Texas at El Paso and Kyoto University
%  originally March 2015, revised December 2015
% Code for experiments in prediction in dialog
%  applied to the fireboy and watergirl data
% As described in the commented-out lines 
%  in c:/nigel/papers/action-prosody/boston.txt

  [~, ff] = makeTrackMonster(trackspec, featurelist);
  normalizedff = [];

  % normalize using nmeans and nstds, from a previously computed rotationspec
  for col=1:length(featurelist)
     normalizedff(:,col) = (ff(:,col) - nmeans(col)) / nstds(col);
  end

  printHeader();
  predictorff = pastOnly(normalizedff, featurelist);
%  [ablatedcoeff, invAblated] = createAblatedRotation(coeff, 1:ndims);

  fprintf(' single-dimension results\n');
  for dim = 1:10
    testDimensionSubset(coeff, predictorff, normalizedff, featurelist, [dim]);
  end
    testDimensionSubset(coeff, predictorff, normalizedff, featurelist, [23]);
    testDimensionSubset(coeff, predictorff, normalizedff, featurelist, [24]);
    testDimensionSubset(coeff, predictorff, normalizedff, featurelist, [25]);
  fprintf(' trying a couple subsets of the dimensions\n');
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, ...
		      [1,2,3,4,6,9,10]);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, ...
		      [1,3,4]);
  fprintf(' using the top %d dimensions; best result so far, gives:\n', ndims);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, 1:ndims);
  fprintf(' compare the self-pros quality of the next line to the previous\n');
  fprintf(' to judge the value of self future action featues\n');
  predictorff = pastOnlyPlusSelfAction(normalizedff, featurelist);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, 1:ndims);

  fprintf(' now, use the self-action-prediction results of the following to fill\n');
  fprintf(' the table and judge the value of interloctutor prosody\n');
  fprintf('Past features except the interlocutor''s prosody features\n')
  predictorff = pastWithoutIntePros(normalizedff, featurelist);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, 1:ndims);
  fprintf('Past features excluding all interlocutor features\n')
  predictorff = selfPastOnly(normalizedff, featurelist);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, 1:ndims);
  fprintf('Past features except the interlocutor''s action features\n')
  predictorff = pastWithoutInteAct(normalizedff, featurelist);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, 1:ndims);

  fprintf(' now, use the INTE-action-prediction results of the following to fill\n');
  fprintf(' the table and judge the value of EXPERT/Self prosody\n');
  fprintf('Past features except the self''s prosody features\n')
  predictorff = pastWithoutSelfPros(normalizedff, featurelist);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, 1:ndims);
  fprintf('Past features excluding all self features\n')
  predictorff = intePastOnly(normalizedff, featurelist);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, 1:ndims);
  fprintf('Past features except self''s action features\n')
  predictorff = pastWithoutSelfAct(normalizedff, featurelist);
  testDimensionSubset(coeff, predictorff, normalizedff, featurelist, 1:ndims);

end


% test the predictive power of the specified list of dimensions
function testDimensionSubset(coeff, predictorff, normalizedff, featurelist, ...
			     dimensionList)
    fprintf('%2d', dimensionList(1));
    [ablatedcoeff, invAblated] = createAblatedRotation(coeff, dimensionList);

    toprotated = predictorff * ablatedcoeff;
    reconstructed = toprotated * invAblated;

    evaluatePredictionQuality(reconstructed, normalizedff, featurelist);
end


function [ablatedCoeff, invAblated] = ...
      createAblatedRotation(coeff, dimensionsToKeep)
  % returns matrices to use to generate predictions using
  % only a subset of the dimensions/patterns
  ablatedCoeff = coeff(:,dimensionsToKeep);

  inverted = inv(coeff);
  % create a mapping that takes top-dimension values to all raw values 
  invAblated = inverted(dimensionsToKeep,:);   
end


function printHeader()
  % header for the prediction quality results
  fprintf('average correlation with actual for reconstructed feature subsets\n');
  fprintf('  se+in,  self,    se-pros, se-action, inte-action\n');
end

% for various subsets of features, compute average prediction quality,
% where each individual feature's prediction quality is the correlation
%  between predicted value and actual-in-corpus value, across all timepoints.
function evaluatePredictionQuality(reconstructed, normalizedff, featurelist)

  ffcount = 0; % number of future features seen
  ffselfcount = 0;  % number of future self seen
  ffselfproscount = 0;  % number of future self prosodic features seen
  ffselfactioncount = 0;  % number of future self action seen
  ffinteactioncount = 0;  % number of future interlocutor action seen

  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    % for each feature, compute correlation of reconstructed vs normalizedff 
    correlations = corrcoef(reconstructed(:,featNum), normalizedff(:,featNum));
    corr = correlations(1,2);
    if thisfeature.startms >= 0       
       ffcount = ffcount + 1;
       futureFeatureCorrelations(ffcount) = corr;
       if thisfeature.side == 'self'
         ffselfcount = ffselfcount + 1;
         futureSelfFeatureCorrelations(ffselfcount) = corr;
         if ismember(thisfeature.featname, ['rf', 'mi', 'ju'])
                ffselfactioncount = ffselfactioncount + 1;
              futureSelfActionFeatureCorrelations(ffselfactioncount) = corr;
	 else 
              ffselfproscount = ffselfproscount + 1;
              futureSelfProsFeatureCorrelations(ffselfproscount) = corr;
	 end
       else 	 % feature.side == inte
         if ismember(thisfeature.featname, ['rf', 'mi', 'ju'])
                ffinteactioncount = ffinteactioncount + 1;
              futureInteActionFeatureCorrelations(ffinteactioncount) = corr;
	 end
       end
    end 
    % print correlation for each feature.  Useful for sanity checks, 
    %  also for graphing predictability as a function of time into future
    %fprintf ('feature %s %d %d %s: corr= %.2f\n', ...
    %	     thisfeature.featname, thisfeature.startms, thisfeature.endms, ...
    %	     thisfeature.side, corr);
  end

  fprintf('  %6.3f %6.3f  %6.3f     %6.3f       %6.3f  \n', ...
	  mean(futureFeatureCorrelations), ...
	  mean(futureSelfFeatureCorrelations), ...
	  mean(futureSelfProsFeatureCorrelations), ...
	  mean(futureSelfActionFeatureCorrelations), ...
	  mean(futureInteActionFeatureCorrelations));
end


% returns a version of normalizedff 
%   with zeros replacing values for all features not to be used for predictions
% Specifically predictorff has values for only the past features
function decimated = pastOnly(normalizedff, featurelist)
  decimated = normalizedff;  
  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    isFuture = (thisfeature.endms > 0);
    if isFuture
      decimated(:,featNum) = zeros(1,length(decimated));  % zap it 
    end 
  end 
end

% same as pastOnly, but also zap interlocutor past prosodic features
function decimated = pastWithoutIntePros(normalizedff, featurelist)
  decimated = normalizedff;  
  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    isFuture = (thisfeature.endms > 0);
    isSelf = (strcmp(thisfeature.side, 'self'));
    isAction = any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']));
    isProsody = ~isAction;

    if isFuture || (~isSelf && isProsody)
      decimated(:,featNum) = zeros(1,length(decimated));  % zap it 
    end 
  end 
end

% same as pastOnly, but also zap interlocutor past prosodic features
function decimated = pastWithoutSelfPros(normalizedff, featurelist)
  decimated = normalizedff;  
  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    isFuture = (thisfeature.endms > 0);
    isSelf = (strcmp(thisfeature.side, 'self'));
    isAction = any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']));
    isProsody = ~isAction;

    if isFuture || (isSelf && isProsody)
      decimated(:,featNum) = zeros(1,length(decimated));  % zap it 
    end 
  end 
end

function decimated = selfPastOnly(normalizedff, featurelist)
  decimated = normalizedff;  
  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    isFuture = (thisfeature.endms > 0);
    isSelf = (strcmp(thisfeature.side, 'self'));

    if isFuture || ~isSelf
      decimated(:,featNum) = zeros(1,length(decimated));  % zap it 
    end 
  end 
end

function decimated = intePastOnly(normalizedff, featurelist)
  decimated = normalizedff;  
  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    isFuture = (thisfeature.endms > 0);
    isSelf = (strcmp(thisfeature.side, 'self'));

    if isFuture || isSelf
      decimated(:,featNum) = zeros(1,length(decimated));  % zap it 
    end 
  end 
end



function decimated = pastWithoutInteAct(normalizedff, featurelist)
  decimated = normalizedff;  
  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    isFuture = (thisfeature.endms > 0);
    isSelf = (strcmp(thisfeature.side, 'self'));
    isAction = any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']));
    isProsody = ~isAction;

    if isFuture || (~isSelf && isProsody)
      decimated(:,featNum) = zeros(1,length(decimated));  % zap it 
    end 
  end 
end

function decimated = pastWithoutSelfAct(normalizedff, featurelist)
  decimated = normalizedff;  
  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    isFuture = (thisfeature.endms > 0);
    isSelf = (strcmp(thisfeature.side, 'self'));
    isAction = any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']));
    isProsody = ~isAction;

    if isFuture || (isSelf && isAction)
      decimated(:,featNum) = zeros(1,length(decimated));  % zap it 
    end 
  end 
end

% same as pastOnly, but preserve self future action features
function decimated = pastOnlyPlusSelfAction(normalizedff, featurelist)
  decimated = normalizedff;  
  for featNum = 1 : length(featurelist)
    thisfeature = featurelist(featNum);
    isFuture = (thisfeature.endms > 0);
    isSelf = (strcmp(thisfeature.side, 'self'));
    isAction = any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']));
    isProsody = ~isAction;

    if (isFuture && ~isSelf) || (isFuture && isProsody)
      decimated(:,featNum) = zeros(1,length(decimated));  % zap it 
    end 
  end 
end

