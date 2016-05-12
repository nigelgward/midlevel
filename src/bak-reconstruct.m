function reconstruct(trackspec, featurelist, nmeans, nstds, coeff, ndims)
  % supports several experiments in prediction, as reported in the Dresden paper 

  fprintf('applying norm+rot to %s channel features for "%s" ... \n', ...
	   trackspec.side, trackspec.filename);

  %ff = makeTrackMonster(trackspec, featurelist);
  [~, ff] = makeTrackMonster(trackspec, featurelist);
  normalizedff = [];

  %normalize using rotationspec nmeans and nstds
  for col=1:length(featurelist)
     normalizedff(:,col) = (ff(:,col) - nmeans(col)) / nstds(col);
  end

  % only work with the top n dimensions
  % and only use the past features
  dimensionsToKeep = ndims;   % 4 gives best performance
  topcoeff = coeff(:,1:dimensionsToKeep);
  ablated = normalizedff;  
  for featureNum = 1 : length(featurelist)
    thisfeature = featurelist(featureNum);
    % zap future dimension (the most basic experiment)
%    if (thisfeature.endms > 0)
    % alternative condition use when testing action features utility to predict prosody
    %if (thisfeature.endms > 0 && ~(strcmp(thisfeature.side, 'self') && any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']))))
    % alternative condition to use when testing other prosody-features value for predicting action
%    if (thisfeature.endms > 0 || strcmp(thisfeature.side, 'inte')) % && any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']))))
%    if (thisfeature.endms > 0 || (strcmp(thisfeature.side, 'inte') && any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']))))
%    if (thisfeature.endms > 0 || (strcmp(thisfeature.side, 'self') && any(ismember(thisfeature.featname, ['rf', 'mi', 'ju']))))
    if (thisfeature.endms > 0 || (strcmp(thisfeature.side, 'self')))
      ablated(:,featureNum) = zeros(1,length(ablated));  % zap it 
    end
    % uncomment to test the value of no past novice prosody for predicting  actions
    %if (strcmp(thisfeature.side, 'inte') && ~any(ismember(thisfeature.featname, ['rf', 'mi', 'ju'])))
     % ablated(:,featureNum) = zeros(1,length(ablated));  % zap it also
    %end
  end 

  % now we have a normalized monster, and have created or looked up the rotation
  toprotated = ablated * topcoeff;

  ffcount = 0; % number of future features seen
  ffselfcount = 0;  % number of future self seen
  ffselfproscount = 0;  % number of future self pros seen
  ffselfactioncount = 0;  % number of future self action seen
  ffinteactioncount = 0;  % number of future self action seen
  % now we unrotate and compare to the original
  inverted = inv(coeff);
  invtop = inverted(1:dimensionsToKeep,:);   % mapping that takes top-dimension values to all raw values 
  reconstructed = toprotated * invtop;
  fprintf ('correlation betwen reconstructed and actual:\n');
  for featureNum = 1 : length(featurelist)
    thisfeature = featurelist(featureNum);
    % for all features, compare correlations between reconstructed and normalizedff
    correlations = corrcoef(reconstructed(:,featureNum), normalizedff(:,featureNum));
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
       else 
	 % feature.side == inte
         if ismember(thisfeature.featname, ['rf', 'mi', 'ju'])
                ffinteactioncount = ffinteactioncount + 1;
              futureInteActionFeatureCorrelations(ffinteactioncount) = corr;
	 end
       end
    end 
    fprintf ('for feature %s %d %d %s is %.2f\n', ...
	     thisfeature.featname, thisfeature.startms, thisfeature.endms, thisfeature.side, corr);
  end
  fprintf('average correlation for reconstructed features was %.3f\n', mean(futureFeatureCorrelations));
  fprintf(' ... for self features was %.3f\n', mean(futureSelfFeatureCorrelations));
  fprintf(' ... for self prosodic features was %.3f\n', mean(futureSelfProsFeatureCorrelations));
  fprintf(' ... for self action features was %.3f\n', mean(futureSelfActionFeatureCorrelations));
  fprintf(' ... for inte action features was %.3f\n', mean(futureInteActionFeatureCorrelations));
end
