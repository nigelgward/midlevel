%function [recalls, precisions, values, reductions, usefuls] = gazePredictor()
function [gazeOnPredOn, gazeOnPredOff, gazeOffPredOn, gazeOffPredOff] = gazePredictor()

% Nigel Ward, University of Texas at El Paso, April 2015

% intended to be run from the directory isg/speech/gaze/singapore
% addpath('../../ppca/src4')
% addpath('../../ppca/voicebox')
% gazePredictor();
%  or 
% [v, r, u] = gazePredictor();
% clf;hold;
% plot(1:30, mean(r),'r.');
% plot(1:30, mean(v),'b--');
% plot(1:30, mean((r+2*v)/3),'k', '-');    % play with the weight to get it concave
% axis([0 14 0 1])
% xlabel('aggressiveness of gaze-off prediction');
% legend('reduction', 'value', 'weighted sum');

fssfile = '../../ppca/src4/eyemouth.fss';  
fssfile = 'mouth.fss';
%fssfile = 'eye.fss';
%fssfile = 'eyemouthinte.fss';
%fssfile = 'eyeinte.fss';
%fssfile = 'mouthinte.fss';
%fssfile = 'gazefive.fss';   % gaze features only 
featurelist = getfeaturespec(fssfile);
trackfile = 'twelvetracks.tl';
%trackfile = 'eleventracks.tl';
%trackfile = 'twotracks.tl';
tracklist = gettracklist(trackfile);

monsters = {};
for trackNum = 1:length(tracklist)
   [startframe, mon] = makeTrackMonster(tracklist{trackNum}, featurelist);
   monsters{trackNum} = mon(startframe:end,:);
end

for testTrackNum = 1:length(tracklist)
  fprintf('\n-------------- testing performance on track %d\n', ...
	  testTrackNum);
  trainingDataStarted = false;	
  for tr = 1:length(tracklist)
    if tr ~= testTrackNum
      if ~trainingDataStarted
	trainingData = monsters{tr};
      else
	trainingData = vertcat(trainingData, monsters{tr});
      end
    end
  end 

  model = trainModel(trainingData(:,1), trainingData(:,2:end));
  displayModel(model, featurelist(2:end));   % first feature is predictee

  testData = monsters{testTrackNum};

  gazeAversions = 1 - testData(:,1);
  nframes = length(testData(:,1));
  for thresholdNum = 1:20
    threshold =  0.05 * (thresholdNum - 1);
    fprintf('\nat threshold %.2f\n', threshold);
    [predictions, likelihoods] = applyModel(model, threshold, testData(:,2:end)); 
    gazeOffPredOff(testTrackNum, thresholdNum) = ...  % correctly not sent 
	    sum(predictions & gazeAversions) / nframes;      
    gazeOnPredOn(testTrackNum, thresholdNum) = ...    % correctly sent
	    sum((1-predictions) & (1-gazeAversions)) / nframes;
    gazeOffPredOn(testTrackNum, thresholdNum) = ...   % incorrectly sent
	    sum((1-predictions) & gazeAversions)  / nframes;     
    gazeOnPredOff(testTrackNum, thresholdNum) = ...   % incorrectly not sent
	    sum(predictions & (1 - gazeAversions)) / nframes;   

    [recall, precision, value, reduction, useful] = ...
	    evaluatePredictions(predictions, gazeAversions); 
    recalls(testTrackNum, thresholdNum) = recall;
    precisions(testTrackNum, thresholdNum) = precision;
    values(testTrackNum, thresholdNum) = value;
    reductions(testTrackNum, thresholdNum) = reduction;
    usefuls(testTrackNum, thresholdNum) = useful;
  end
end

end

%-----------------------------------------------------------------------------
function model =  trainModel(trainingOutcomes, trainingFeatureValues)
  [npoints nfeatures] = size(trainingFeatureValues);
  rinput = [ones(npoints, 1) trainingFeatureValues];
  weights = regress(trainingOutcomes, rinput);
  model = weights;
end

%-----------------------------------------------------------------------------
function displayModel(model, featurenames)
  fprintf('Regression-model weights for predicting gaze-on are: \n');
  fprintf('  %6.3f for %s\n', model(1), 'constant term'); 
  % the first item in featurenames the to-be-predicted buy, so skip it
  for i = 1:length(featurenames)
    fprintf('  %6.3f for %s\n',  model(i+1), featurenames(i).abbrev);
  end
end

%-----------------------------------------------------------------------------
% predict gaze-off
function [predictions, likelihoods] = ...
	    applyModel(weights, threshold, testsetFeatureValues)
  minput = [ones(length(testsetFeatureValues),1) testsetFeatureValues];
  likelihoods = minput * weights;
%  fprintf('  mean(likelihoods) is %f\n', mean(likelihoods));
  predictions = likelihoods < threshold;    
end   

%-----------------------------------------------------------------------------
% compute precision and recall for gaze-off decisions
% compare predictions (decisions) with ground truth (actualResults)
function [recall, precision, value, reduction, usefulFrameRatio] = ...
	    evaluatePredictions(decisions, actualResults)
  nframes = length(actualResults);
  nGazeOff = sum(actualResults);
  nGazeOn = sum(1-actualResults);
  nPredictedOff = sum(decisions);
  nPredictedOn = sum(1-decisions);

  correctlyNotSent = sum(decisions & actualResults);   
  correctlySent = sum((1-decisions) & (1-actualResults));
  incorrectlySent = sum((1-decisions) & actualResults);   
  incorrectlyNotSent = sum(decisions & (1 - actualResults));  

  fprintf('correctlySent, %d, incorrectlyNotSent %d, incorrectlySent %d, correctlyNotSent %d, nframes %d\n', ...
     correctlySent, incorrectlyNotSent, incorrectlySent, correctlyNotSent, nframes);

  recall = correctlyNotSent / nGazeOff;
  precision = correctlyNotSent / nPredictedOff;
  fMeasure = recall * precision / (recall + precision);

  reduction = nPredictedOff/nframes;
  fprintf('  reduction=%.2f', reduction);



  framesViewed = 0.93 * correctlySent + 0.13 * incorrectlySent;
  fprintf('  framesViewed %.1f\n', framesViewed);
  if nPredictedOn == 0
     oldutilityRatio = 1.0;   % prevent NaN
  else
     oldutilityRatio = framesViewed / nPredictedOn; % viewed / sent
  end
  usefulFrameRatio = framesViewed / nframes;

  fprintf('  usefulFrameRatio =%.2f', usefulFrameRatio);
  fprintf('=%.1f / %d\n', framesViewed, nframes);

  value = correctlySent / nframes;
%  fprintf('  value is %.2f (= %d/%d)\n',  value, correctlySent, nframes);
  fprintf('  Recall is %.2f (= %d/%d)', recall, correctlyNotSent, nGazeOff);
  fprintf('  Precision is %.2f (= %d/%d)', precision, correctlyNotSent, nPredictedOff);
  fprintf('  F Measure is %.3f\n', fMeasure);
  end

