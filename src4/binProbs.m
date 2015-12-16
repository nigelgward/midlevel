function binProbs = getBinProbs(binCenters, values)
   % given some values and a set of bins, compute the probability in each bin
  binBoundaries = (binCenters(2:end) + binCenters(1:end-1) ) / 2.0;
  nbins = length(binCenters);
  binCount(1) = sum(values(:) < binBoundaries(1));
  binCount(nbins) = sum(values(:) > binBoundaries(nbins - 1));
  for i=2:(nbins-1)
      binCount(i) = ...
	 sum(values(:) > binBoundaries(i-1) & values(:) < binBoundaries(i));
  end
  binProbs = binCount / length(values);

