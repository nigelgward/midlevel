function baselinepredict(trackspec, featurelist, nmeans, nstds)
% supports several experiments in prediction, as reported in the Dresden paper

load baseLineTrainParams.mat;

fprintf('applying norm+rot to %s channel features for "%s" ... \n', ...
    trackspec.side, trackspec.filename);

[~, ff] = makeTrackMonster(trackspec, featurelist);
normalizedff = [];

%normalize using rotationspec nmeans and nstds
for col=1:length(featurelist)
    normalizedff(:,col) = (ff(:,col) - nmeans(col)) / nstds(col);
end

predictedResult = applyModel(model, normalizedff( : , pastFeatureIndex));
ffcount = 0; % number of future features seen
ffselfcount = 0;  % number of future self seen
ffselfproscount = 0;  % number of future self pros seen
ffselfactioncount = 0;  % number of future self action seen
ffinteactioncount = 0;  % number of future self action seen
reconstructed = predictedResult;
fprintf ('correlation betwen reconstructed and actual:\n');
%for featureNum = 1 : length(featurelist)
for featureNum = 1 : length(futureFeatureIndex)
    %thisfeature = featurelist(featureNum);
    featureNumberInFSSFile = futureFeatureIndex(featureNum);
    thisfeature = featurelist(featureNumberInFSSFile);
    % for all features, compare correlations between reconstructed and normalizedff
    
    correlations = corrcoef(reconstructed(:,featureNum), normalizedff(:,featureNumberInFSSFile));
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
            end %end if
        else
            % feature.side == inte
            if ismember(thisfeature.featname, ['rf', 'mi', 'ju'])
                ffinteactioncount = ffinteactioncount + 1;
                futureInteActionFeatureCorrelations(ffinteactioncount) = corr;
            end %end if
        end %end if
    end %end for
    fprintf ('for feature %s %d %d %s is %.2f\n', ...
        thisfeature.featname, thisfeature.startms, thisfeature.endms, thisfeature.side, corr);
    
end %end of for

fprintf('average correlation for reconstructed features was %.3f\n', mean(futureFeatureCorrelations));
fprintf(' ... for self features was %.3f\n', mean(futureSelfFeatureCorrelations));
fprintf(' ... for self prosodic features was %.3f\n', mean(futureSelfProsFeatureCorrelations));
fprintf(' ... for self action features was %.3f\n', mean(futureSelfActionFeatureCorrelations));
fprintf(' ... for inte action features was %.3f\n', mean(futureInteActionFeatureCorrelations));


end %end of function


%function apply model
function [predictions, likelihoods] = applyModel(weights, testsetFeatureValues)
likelihoods = testsetFeatureValues * weights;
%predictions = likelihoods > 0.20;    % this threshold is pretty arbitrary
predictions = likelihoods;
end %end of function applyModel