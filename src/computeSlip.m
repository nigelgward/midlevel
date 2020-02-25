% computeSlip.m
% Nigel Ward, University of Texas at El Paso and Kyoto University
% January 2016

% OBSOLETE.  REPLACED BY MISALIGNMENT.M.

% Conceptually what's happening is that, at each energy time point, we
%  gather evidence for that being aligned with pitch timepoints offset
%  to the left and to the right.
% Of course we only care about peaks.  Other points get no vote,
%   unless they're a little bit peak-like, in which case they get a little vote
%
% The calling function will later windowize the result

function [slippage, offsetEvidence] = computeSlip(epeaky, ppeaky)

  if length(epeaky) ~= length(ppeaky)
    fprintf('computeSlip: input lengths not equal; cannot recover!\n');
    return
  end

  minDelayFrames = -19;    % until recently was -19 
  maxDelayFrames =  20;    % until recently was 20
  delayStep = 3;
  delays = minDelayFrames:delayStep:maxDelayFrames;

  % offsetEvidence stores, for each timepoint and each delay, 
  %   the strength of evidence for that delay of that magnitude there.
  % weightedPulls is the same but weighted, so it contains
  %   in each element the amount of evidence for a pull to the left or right
  offsetEvidence = zeros(length(delays), length(epeaky));
  weightedPull = zeros(length(delays), length(epeaky));

  for delayIndex = 1:length(delays)
    delay = delays(delayIndex);  
    pull = ppeaky .* shift(epeaky,delay);
    offsetEvidence(delayIndex,:) = pull;   
    weightedPull(delayIndex,:) = pullStrength(delay) * offsetEvidence(delayIndex,:);
  end
  
  % strength of pull is the strength of pull towards one direction or the other
  % times the total evidence for the existence of cohabiting energy and pitch peaks
  %   in the region
  slippage = mean(weightedPull) .* sum(offsetEvidence); % until recently was .* epeaky'; 
  % So far things have been positive when the pitch is right-shifted.
  % If it aligns best when right-shifted, that means the pitch comes early
  %  and conversely, negative values mean a delayed pitch peak.
  % At this point we reverse the sign, so that delayed pitch peaks are positive slippage
  slippage = -slippage;

 %  max might also be reasonable ...
  [maxval, maxloc] = max(offsetEvidence); 
  % maxloc is a number from 1 to length(delays)
  slippageInFrames = (maxloc - 1) * delayStep + minDelayFrames;
  slippageInFrames = slippageInFrames .* ppeaky' * 50;
  slippage = slippageInFrames * 0.0002;  % reduce for nice display
end
% test data
% computeSlip([1 1 1 1 2 3 2 1 1 ], [1 1 1 1 1 1 2 3 2 ])
%  should return positive values in the middle
% computeSlip([1 1 1 1 1 1 3 2 0 ], [1 1 1 1 3 2 0 1 1 ])
%  should return negative values in the middle
% (both will return junk at the ends)

% do this to attenuate the weight given to the evidence for longer pulls,
% since those are often implausible (true?)
function pull = pullStrength(delay)
  pull = sign(delay) * sqrt(abs(delay));
end

function shifted = shift(vec, offset)
  if offset == 0
    shifted = vec;
  end
  if offset > 0
      shifted = [zeros(offset,1);  vec(1:end-offset)];
  end
  if offset < 0 
    shifted = [vec(-offset+1:end) ; zeros(-offset, 1)];
  end
end
% test data
% shifted([3 1 1 1 2 1 1 1 1 3], 0);
% shifted([3 1 1 1 2 1 1 1 1 3], -1);
% shifted([3 1 1 1 2 1 1 1 1 3], +1);