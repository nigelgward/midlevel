function vec = speakingFrames(logEnergy)
  % returns a vector of 1s and 0s
  % Nigel Ward, UTEP, Feb 2017

  % This could use a standard VAD, tho they have a lot of assumptions,
  % or some more sophisticated algorithm

  % find silence and speech mean of track using k-means
  [silence_mean,speech_mean] = findClusterMeans(logEnergy);
  
  % Set the speech/ilence threshold closer to the silence mean
  % because the variance  of silence is less than that of speech
  % This is ad hoc; modeling with two gaussians would probably be better
  threshold = (2 * silence_mean + speech_mean) / 3.0;

  vec = logEnergy > threshold;
end
