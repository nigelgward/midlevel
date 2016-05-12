function trainBaseLine(tlfile, featuresetSpec, ndims)
%% Saiful Abu and Nigel Ward, UTEP, May 2015

%% tests the ability of the the linear regression learning model
%% predict feature values for future

%% To test
%%   1. cd isg/speech/watergirl/dimensions/
%%   2. trainBaseLine('oddfiles.tl', 'dresden.fss');
%%   3. baselinepredictorDriver('../unseenone.tl', 'dresden.fss');
load rotationspec   % get nmeans, nstds, and coeff, written by findDimensions.m
featurelist = getfeaturespec(featuresetSpec);
% clear statistics file, since we'll be appending to it; ok if this fails
% system('rm summary-stats.txt');

%store past and future feature index
pastFeatureIndex = [];
futureFeatureIndex = [];

for featureNum = 1 : length(featurelist)
    thisfeature = featurelist(featureNum);
    if (thisfeature.endms > 0)
        futureFeatureIndex = [futureFeatureIndex featureNum];
    else
        pastFeatureIndex = [pastFeatureIndex featureNum];
    end%end if else
end %end for

%accumulate train data
traindData = [];
tracklist = gettracklist(tlfile);
for filenum = 1:length(tracklist)
    trackspec = tracklist{filenum};
    fprintf('reconstructing  %s of %s ,\n using features %s %s at %s \n ', ...
        trackspec.side,  trackspec.filename, ...
        featuresetSpec, datestr(clock));
    %baselinepredict(trackspec, featurelist, nmeans, nstds);
    %get data from track and normalize it
    [~, ff] = makeTrackMonster(trackspec, featurelist);
    normalizedff = [];
    %normalize using rotationspec nmeans and nstds
    for col=1:length(featurelist)
        normalizedff(:,col) = (ff(:,col) - nmeans(col)) / nstds(col);
    end %end for
    traindData = [traindData ; normalizedff];
end%end for

%train model
model = trainModel(traindData(:, futureFeatureIndex), traindData(:, pastFeatureIndex));

%save training outcome
save('baseLineTrainParams.mat', 'model', 'pastFeatureIndex', 'futureFeatureIndex');

end %end of function


%function train model
function model =  trainModel(trainingOutcomes, trainingFeatureValues)
%weights = regress(trainingOutcomes, trainingFeatureValues);
weights = [];
[~, trainingDataFeatureSize] = size(trainingOutcomes);
for i = 1 : trainingDataFeatureSize
    w_i = regress(trainingOutcomes(: , i), trainingFeatureValues);
    weights = [weights w_i];
end
model = weights;
end %end of function trainModel
