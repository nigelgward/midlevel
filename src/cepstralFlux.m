function flux = cepstralFlux(signal, rate, energy)

  %% Nigel Ward, UTEP, December 2016

  %% Testing on ../flowtest/prefix21d.au, I observe that:
  %% - this is strongly high when the speaking rate is high
  %% - and also during very creaky regions, even if they sound lengthened,
  %% - very low during silence
  %% - generally moderately low during lengthenings
  %% computeLengthening() the flux returned by this function

  %  [r,s] = readtracks(aufile);
  %  speech = s(:,1);  % left track

  % mfcc parameters taken straight from Kamil Wojcicki's mfcc.m documentation 
  cc = mfcc(signal, rate, 25, 10, .97, @hamming, [300 3700], 20, 13, 22);
  cc = [zeros(13,1)  cc  zeros(13,1)];  % pad, due to the window size

  % these two lines are experimental
  %denominator = repmat(energy, size(cc,1), 1);
  %cc = cc ./ denominator;

  smoothingSize = 15;   % smooth over 150ms windows 
  cct = cc';
  diff = cct(2:end,:) - cct(1:end-1,:);
  if length(diff) < length(energy)
     % pad it with a convenient value
    avgdiff = mean(abs(diff));
    diff = [avgdiff; diff];  

  end
  diffSquared = diff .*diff;
  sumdiffsq = sum(diffSquared,2);
  %% perhaps we should normalize at this point,
  %%   e.g. sumdiffsq = summdiffsq / mean(summdiffsq)
  %% to compensate for speaker variation in how much they habitually enunciate
  %%  and or variation in typical speaking rate
	    % the function smooth is not in every Matlab release,
	    % but there's an alternative implementation here in smoothJcc.m
  smoothed = smoothJcc(sumdiffsq, smoothingSize);  
  % plot(smoothed);
  flux = smoothed;
end

