function winLengthening = computeLengthening(relevantEnergy, relevantFlux, duration)

  %% Nigel Ward, UTEP, December 2016
  

  %%nanFraction = sum(isnan(relevantFlux))/length(relevantFlux);
  %%fprintf('                      fraction of NaNs in relevantFlux is %.4f\n', ...
  %%     nanFraction);
  %%fprintf('mean(relevantFlux) = %.2f\n', mean(relevantFlux));
  %%fprintf('std(relevantFlux) = %.2f\n', std(relevantFlux));
  %%fprintf('max(relevantFlux) = %.2f\n', max(relevantFlux));
  %%fprintf('min(relevantFlux) = %.2f\n', min(relevantFlux));
  nonNanMean = mean(relevantFlux(~isnan(relevantFlux)));
  nonNanStd = std(relevantFlux(~isnan(relevantFlux)));
  
  relevantFlux(isnan(relevantFlux)) = nonNanMean;   % kill the NaNs

  maxPlausible = nonNanMean + 3 * nonNanStd;    % saw terrible outliers at the start of a file 
  relevantFlux(relevantFlux > maxPlausible) = maxPlausible;
  if ismember(0, relevantFlux)             % replace zeros with a small value
    relevantFlux(relevantFlux==0) = nonNanMean / (3 * nonNanStd);
  end

  %% note that we could instead do relevantEnergy - c1 * relevantFlux,
  %% for some constant c1, following Gabriel Skantze's in his Sigdial 2017 paper.
  lengthening = relevantEnergy' ./ relevantFlux;

  if isnan(sum(lengthening))
    fprintf('NaN found in computeLengthening\n');
  end    
  lengthening(lengthening == Inf) = 0;
  lengthening(lengthening == NaN) = 0;
  winLengthening = windowize(lengthening', duration)';
end
