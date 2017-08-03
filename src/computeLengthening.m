function winLengthening = computeLengthening(relevantEnergy, relevantFlux, duration)

  %% Nigel Ward, UTEP, December 2016

  if ismember(0, relevantFlux)
    %% replace it with a small value
    relevantFlux(relevantFlux==0) = min(relevantFlux(relevantFlux>0));
  end
  %% note that we could instead do relevantEnergy - c1 * relevantFlux,
  %% for some constant c1, following Gabriel Skantze's in his Sigdial 2017 paper.
  lengthening = relevantEnergy' ./ relevantFlux;

  lengthening(lengthening == Inf) = 0;
  lengthening(lengthening == NaN) = 0;
  winLengthening = windowize(lengthening', duration)';
end
