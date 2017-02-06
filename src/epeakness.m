% epeakness.m  Energy Peakness
% Nigel Ward, University of Texas at El Paso and Kyoto University
% January 2016

% Input: a vector of energy-vs-time
%    positive and typicallly ranges from about 5 to 10 
% Output: a vector of the same size whose
%    value at each point represents the likelihood/strength of a peak there
%
% To count as a peak, three properties are important:
% 1. the point globally high-energy, relative to the whole dialog
% 2. the point is high footwise, that is, it's high relative to
%    the average over the local few syllables, to see if this
%   one is a stressed syllable in the midst of unstressed ones 
% 3. the point is high in its syllable one.
%
% In my voice, stressed syllables seem to be 180ms or so, if monolog,
%  probably longer for dialog; probably longer for normal people.
% So we want the above-zero part of the filter to be around that size,
%  or 20 frames, so create a LoG with a half-width (sigma) of 10  
% (Or so I thought when I was tring to do everything sith a single LoG filter)

% The downstream use of this is to compare the location of the pitch peak,
%  to find places where the pitch peak is late relative to the energy peak

% This seems to work decently well for English, mostly falling
% in syllable centers.  However for Slovak it often falls earlier, 
% at the initial consonant release, since they lack the aspiration which
% in English attenuates the intensity of such bursts. 

function peakness = epeakness(vec)
  iSFW = 6;  % in-syllable filter width, in frames
  iFFW = 15; % in-foot filter width, in frames

  height = sqrt( (vec - min(vec)) / (max(vec) - min(vec))); 
  inSyllablePeakness = myconv(vec, laplacianOfGaussian(iSFW), iSFW * 2.5);
  inFootPeakness     = myconv(vec, laplacianOfGaussian(iFFW), iFFW * 2.5);

  peakness = inSyllablePeakness .* inFootPeakness .* height;

  peakness(peakness<0) = 0;  % since we don't consider troughs when aligning

end


% Validation
% eyeballing some graphs, it seems that for energy this is a 
%  fairly decent syllable detector, at least for the stressed
%  syllables, which are decently long and decently separated
%  from their neighbors.  I don't care the others, the slurred ones.
