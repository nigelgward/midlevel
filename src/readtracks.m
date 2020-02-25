function [rate, signals] = readtracks(file)

%% Given a stereo audio filename 
%%  reads the file and returns two signals 
%% It's best to avoid wav files; since they can cause errors downstream

%% test with [r,s] = readtracks('../flowtest/21d.au')

%% since this code requires readau, will need to do:  addpath('../voicebox');

  [pathstr, name, ext] = fileparts(file);
  switch ext
    case '.au'
      [signals, rate, headerinfo] = readau(file);
    case '.wav' 
      [signals, rate, wmode, fidx] = readwav(file);
    case '.WAV' 
      [signals, rate, wmode, fidx] = readwav(file);
    otherwise
      disp(ext)
      warning ('for file %s, unexpected extension %s , so  skipping it', file, ext);
      return
  end

  dimensions = size(signals);
  channels = dimensions(2);
  if channels ~= 2 
    %%      warning ('not a stereo file');
  end
  if rate ~= 8000 && rate ~= 16000
    %% higher rates seem to confuse the pitch tracker,
    error('sorry: sampling rate must be 8000 or 16000, not %d\n', rate);
  end
end
  
  


