function lengthening = computeLengthening(relevantEnergy, relevantFlux, duration)
  if ismember(0, relevantFlux)
    % replace it with a small value
    relevantFlux(relevantFlux==0) = min(relevantFlux(relevantFlux>0));
  end
  lengthening = relevantEnergy' ./ relevantFlux;
  lengthening(lengthening == Inf) = 0;
  lengthening(lengthening == NaN) = 0;
  lengthening = windowize(lengthening', duration)';
end
