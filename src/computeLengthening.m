function lengthening = computeLengthening(relevantEnergy, relevantFlux)
  lengthening = relevantEnergy' ./ relevantFlux;
  lengthening(lengthening == Inf) = 0;
end
