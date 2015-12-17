function[paddedPitch, paddedCenters] = lookupOrComputePitch(directory, savekey, signal, rate)

% Savekey encodes the audio filename and the track.
% If a cached pitch file exists, then use that data 
%  otherwise compute pitch and save it 
% Return a vector of pitch points and a vector of where they are, in ms

msPerSample = 1000 / rate;

pitchCacheDir = [directory 'pitchCache'];

if ~exist(pitchCacheDir, 'dir')
  mkdir (pitchCacheDir);
end

pitchFileName = [pitchCacheDir '/pitch'  savekey '.mat'];

if (exist(pitchFileName, 'file' ) == 2)
   fprintf('reading cached pitch file %s\n', pitchFileName);
   load(pitchFileName)
else
  fprintf('computing pitch for %s %s  \n', savekey);
tic
  [pitch, startsAndEnds] = fxrapt(signal, rate, 'u');
toc
  save( pitchFileName, 'pitch', 'startsAndEnds');      % write it as a .mat file
end

% The first pitch point fxrapt returns is for a frame from 15ms to 25ms, 
%  thus centered at 20ms into the signal.
% The last one is similarly short of the end of the audio file. 
% So we pad. 
paddedPitch = vertcat([NaN], pitch, [NaN]);

pitchCenters = 0.5 * (startsAndEnds(:,1) + startsAndEnds(:,2)) * msPerSample;
% we know that pitchpoints are 10 milliseconds apart
paddedCenters = vertcat([pitchCenters(1) - 10], pitchCenters, [pitchCenters(end) + 10]);


% test with 
% [r, ss] = readtracks('../minitest/short.au');
% lookupOrComputePitch('temporary', ss(:,1), 8000);
