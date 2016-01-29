% misalignment.m 
% 
% in ppca/src/   Nigel Ward, UTEP and Kyoto U, January 2016
%
% inspired by the need to estimate pitch-peak delay, 
% but a much simpler conception: just measure misalignment
% don't worry whether it's pulled forward or back
% because who can tell? without a stressed-syllable oracle
% note that a more traditional, but less reliable, estimator is computeSlip.m
% 
% Note that misalignments are only salient if they come at a peak.
% see also comments in ../sliptest/README.TXT

function estimate = misalignment(epeaky, ppeaky)

  localMaxEPeak = findLocalMax(epeaky, 120);

  expectedProduct = localMaxEPeak .* ppeaky;
  actualProduct = epeaky .* ppeaky;  

  estimate = (expectedProduct - actualProduct) .* ppeaky;
end


% Return a vector where each element e is 
%  the max value found a window of size width centered about position e.
% Maybe should have a discount factor for elements further off,
%  or otherwise soften the edges of this filter
function mx = findLocalMax(vector, widthMs)
  halfwidthFrames = (widthMs / 2) / 10;
  mx = zeros(length(vector), 1);
  for e = 1:length(vector)  
     startframe = max(1, e - halfwidthFrames);
     endframe = min(e + halfwidthFrames, length(vector));
     mx(e) = max(vector(startframe:endframe));
  end
end

% test with
%findLocalMax([1 2 3 4 1 2 3 4 1 1 2 4 5 7 1 1 1 1 2], 60)';

   
