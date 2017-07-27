function vec = speakingFrames(logEnergy)
  %% returns a vector of 1s and 0s
  %% Nigel Ward, UTEP, Feb 2017

  %% This is very simplistic, but adequate for the current uses. In
  %% future, it might be replaced by  a standard VAD, tho they have a
  %% lot of assumptions, or some more sophisticated algorithm.  A
  %% simpler change would be to smooth/debounce, since single isolated
  %% frames of speech or silence don't exist.

  %% find silence and speech mean of track using k-means
  [silenceMean, speechMean] = findClusterMeans(logEnergy);
  
  %% Set the speech/silence threshold closer to the silence mean
  %%   because the variance of silence is less than that of speech.
  %% This is ad hoc; modeling with two gaussians would probably be better
  threshold = (2 * silenceMean + speechMean) / 3.0;

  vec = logEnergy > threshold;
end
