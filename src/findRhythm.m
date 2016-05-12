% Nigel Ward, UTEP, 2014-2015
% findRhythm.m ... 
% written to see whether there are common rhythms in English,
%  at different frequencies, each with a different meaning.

% addpath ....
% findRhythm('audio-clips/herandy7')

% conclusion (by running on audio in natives-au)
% some seem to have bumps at certain frequencies
%  e.g. eng2 both left and right tracks
%  but they may be noise
%  and the frequency is not consistent across speakers
% so the hypothesis is not supported

function findRhythm(audiofile, tracknum)
  cummulative = zeros(1,301);

  [rate, signalPair] = readtracks(audiofile);

  signal = signalPair(:,tracknum);
  msPerFrame = 10; 
  samplesPerFrame = msPerFrame * (rate / 1000);
  energy = computeLogEnergy(signal', samplesPerFrame);

  for i=1:2:length(energy)-601  % step every 2 frames (20 ms)
    energyVsFreq = fftChunk(energy, i);
    cummulative = cummulative + energyVsFreq;

  end 
  f = 100*(0:(600/2))/600;   % mimicking the fft documentation to get hertz
  plot(f(2:50), cummulative(2:50));

end

function evf = fftChunk(vector, startSample)
  
  sixseconds = vector(startSample:startSample+600);

  % sampling period is 10ms
  y = fft(sixseconds);
  p2 = abs(y/600);
  p1 = p2(1:600/2+1);
  p1(2:end-1) = 2 * p1(2:end-1);

%  f = 100*(0:(600/2))/600;   % mimicking the fft documentation
%  plot(f, p1);

  evf = p1;  % return energy vs frequency
  evf = sharpen(evf);
end

function s = sharpen(vec)
  tmp = 3 * [vec(1) vec vec(end)] - [vec(1) vec(1) vec] - [vec vec(end) vec(end)];
  tmp = 3 * [0 vec 0]  - [0 0 vec] - [vec 0 0];
  s = tmp(2:end-1);
end
