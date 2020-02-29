function[paddedPitch, paddedCenters] = ...
	lookupOrComputePitch(directory, savekey, signal, rate)

  %% Return a vector of pitch points and a vector of where they are, in ms
  %% called by makeTrackMonster

  %% the savekey is just the concatenation of a filename with 'l' or 'r' 

  %% This is a little messy  since I modified it to work also for
  %%  Switchboard, since fxrapt sometimes fails on those files.  For
  %%  that, I've used reaper to generate f0 files, using
  %%  istyles/code/sph-to-splitttrack-wav.sh, and those files are
  %%  saved in reaperf0/, a sister directory of the wavfiles
  %%  directory, and then read here. 

  %% Otherwise I just call fxrapt.  Howver, since it's slow, I cache
  %%   those results as a matlab file.  Thus, if  a cached pitch file
  %%   exists, then use that data otherwise call fxrapt to compute the
  %%   pitch and save it
  %% Savekey encodes the audio filename and the track, for caching purposes

  msPerSample = 1000 / rate;
  audioFileName = [directory, savekey(1:end-1)];
  audioFileBase = [savekey(1:end-5)];
  channel = savekey(end:end);

  reaperF0Dir = [directory '../f0reaper'];
  if exist(reaperF0Dir, 'dir')
    reaperFile =  sprintf('%s-%s-f0.txt', audioFileBase, channel);
    reaperPath =  [reaperF0Dir '/' reaperFile];
    reaperOutput =  readmatrix(reaperPath, 'NumHeaderLines', 7);
    pitch = reaperOutput(:,3);   % note that these are -1 if no pitch
    pitch(pitch == -1) = NaN;
    %% first reported pitch value is at 0ms, which seems wrong, so pad and shift by 10ms 
    paddedPitch = vertcat([NaN], pitch);
    paddedCenters = 10 + reaperOutput(:,1);  
    return
  end
  
  %% otherwise the reaperF0 files were not created, since not needed, so can use fxrapt

  pitchCacheDir = [directory 'pitchCache'];
  if ~exist(pitchCacheDir, 'dir')
    mkdir (pitchCacheDir);
  end
  pitchFileName = [pitchCacheDir '/pitch'  savekey '.mat'];
  
  if exist(pitchFileName, 'file') ~= 2
    fprintf('computing pitch for %s %s  \n', savekey);
    [pitch, startsAndEnds] = fxrapt(signal, rate, 'u');
    save(pitchFileName, 'pitch', 'startsAndEnds');      
  else
    if file1isOlder(pitchFileName, audioFileName)
      fprintf('recomputing pitch for %s %s  \n', savekey);
      [pitch, startsAndEnds] = fxrapt(signal, rate, 'u');
      save(pitchFileName, 'pitch', 'startsAndEnds');     
    else
      %% fprintf('reading cached pitch file %s\n', pitchFileName);
      load(pitchFileName)
    end
  end
  
  %% The first pitch point fxrapt returns is for a frame from 15ms to 25ms, 
  %%  thus centered at 20ms into the signal.
  %% The last one is similarly short of the end of the audio file. 
  %% So we pad. 
  paddedPitch = vertcat([NaN], pitch, [NaN]);
  
  pitchCenters = 0.5 * (startsAndEnds(:,1) + startsAndEnds(:,2)) * msPerSample;
  %% we know that pitchpoints are 10 milliseconds apart
  paddedCenters = vertcat([pitchCenters(1) - 10], pitchCenters, [pitchCenters(end) + 10]);
end

%% to test
%%   [r, ss] = readtracks('21d.au');
%%   lookupOrComputePitch('', '21d.au', ss(:,1), r);

% to test for reading reaper pitch data
%%   cd istyles/shortTests 
%%   [r, ss] = readtracks('initial10s-2001.wav');
%%   lookupOrComputePitch('temporary', ['initial10s-2001.wav' 'l'], ss(:,1), r);



%% ------------------------------------------------------------------
function isOlder = file1isOlder(file1, file2)
  file1Info = dir(file1);
  file2Info = dir(file2);
  isOlder = file1Info.datenum < file2Info.datenum;
end

