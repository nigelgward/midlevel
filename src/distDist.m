function distDist(refvals, natvals, nonvals)
% print out the distribution differences, for each dimension
% Nigel Ward, UTEP, February 2015
nbins = 20; 
for dim=1:30   % later do more
  % first, define 20 bins based on the reference values
  [refBinCounts, refBinCenters] = hist(refvals(:,dim), nbins);

  % actually hist() with a vector second argument could do this
   natBinProbs = binProbs(refBinCenters, natvals(:,dim));  
   nonBinProbs = binProbs(refBinCenters, nonvals(:,dim));
   refBinProbs = binProbs(refBinCenters, refvals(:,dim));

   natRefDistance = bhatd(natBinProbs, refBinProbs);
   nonRefDistance = bhatd(nonBinProbs, refBinProbs);

   fprintf('dimension %2d distances: nat-ref %.3f, non-ref %.3f   %d\n', ...
      dim, natRefDistance, nonRefDistance, nonRefDistance > natRefDistance);
end


% test with distDist(rand(50,10), rand(50,20), 1.2 * rand(60,10));