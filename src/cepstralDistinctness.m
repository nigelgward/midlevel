function windowVec = cepstralDistinctness(signal, rate, pitch, duration, flag)

  % Nigel Ward, January 2017
  % code derived from cepstralFlux.m; see comments there

  % A good measure of phonetic reduction vs enuciation
  %  is the degree to which vowels are centralized vs distinct
  % This function measures as a proxy how spectrally close or far from
  %  the average are the voiced segments
  % returns the degree of evidence for reduction or enunciation

  % I'm being here careful to exclude unvoiced segments from consideration
  %  tho maybe if I sloppily included them, it wouldn't matter.
  % In dialog, it's probably not common for just one phoneme to be
  %  reduced, so it's probably appropriate to compute these over
  %  no less than a couple of syllables, say 300ms as a minimum window.
  % To make this a better gauge of what''s happing at syllable centers,
  %  could multiply by energy and/or exclude frames without a valid 
  %  pitch point on both sides.

  % This code fails on the Toyota data, producing lots of NaNs; don't know why.

  cc = mfcc(signal, rate, 25, 10, .97, @hamming, [300 3700], 20, 13, 22);
  cc = [zeros(13,1)  cc  zeros(13,1)];  % pad, due to the window size
  cct = cc';

  nframes = length(pitch);
  cctlen = length(cct);
	       %  fprintf('nframes %d, cctlen %d\n', nframes, cctlen);
  switch (cctlen - nframes)
    case 2
      cct = cct(2:end-1,:);  % drop the first point and the last one
    case 1
      cct = cct(2:end,:);  % drop the first point 
    otherwise
      fprintf('problem in cepstralDistinctness %d %d\n', nframes, cctlen);
  end
  
  pitchIndices = find(~isnan(pitch));

  averageCepstrals = mean(cct(pitchIndices,:),1);
  repeatedAverages = repmat(averageCepstrals, nframes, 1);
  % maybe should square before summing 
  cepstralDistances = sum(abs(cct - repeatedAverages),2);  

%  plotRawCDs(cepstralDistances, pitch, pitchIndices);

  voicedCDs = cepstralDistances(pitchIndices);
  cdAvg = mean(voicedCDs);
  cdStdDev = std(voicedCDs);

  framevec = zeros(nframes,1);
  normalizedCDs = (cepstralDistances - cdAvg) / cdStdDev;
  framevec(pitchIndices) = normalizedCDs(pitchIndices);

  pitchValid = ~isnan(pitch);
  pitchValidCount = windowize(pitchValid', duration);
  vecSupport = windowize(framevec', duration);
  
  windowVec = vecSupport ./ pitchValidCount;
  windowVec(isnan(windowVec)) = 0;

  if strcmp(flag, 'enunciation')
    windowVec = max(0, windowVec);  % only care about positive evidence
  elseif strcmp(flag, 'reduction')
    windowVec = max(0, - windowVec); % ditto
  else
    fprintf('cepstralDistances: bad flag %s\n', flag)
  end


%%  plot(windowVec);
end

% tested using validateFeature.m on 21d.au
% Sadly, processing of this audio file seems suffer a lot of bleeding,
%  or something: pitch points in the left track where I hear nothing.
% Although when I listen I don't hear much bleeding at all.

% Anyway, the left track, seems generally very enunciated, but
% extra-enunciated sometimes
% and sometimes reduced, e.g.
%  at the umms, e.g. 5.5, 19, 61.5, 93
%  and at quiet afterthoughts, 25.5, 31.5
%  and at discourse markers, 19.4, 81, 115.5
%  etc 71.5, 106.5
% examining the 'cd' and 'cb' plots, it generally seems to do well,
%  though with a lot of noise ... maybe due to the consonants.

function plotRawCDs(cepstralDistances, pitch, pitchIndices)
  clf
  hold on
  plot(cepstralDistances);
  plot(100 + pitch / 10);
  plot(pitchIndices, cepstralDistances(pitchIndices));
  legend('cepstralDistances', 'pitch', 'cepstralDistances in voiced regions');
  ax = gca;
  ax.XTick = [0:500:12000];
end
