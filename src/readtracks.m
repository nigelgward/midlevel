function [rate, signals] = readtracks(file)
% Given a stereo audio filename 
%  reads the file and returns two signals 
% It's best to avoid wav files; since they can cause errors downstream

% test with [r,s] = readtracks('../minitest/21d.au')

% don't forget to make readau findable: addpath('../voicebox');
  disp(file);
  [pathstr, name, ext] = fileparts(file);
  switch ext
    case '.au'
      [signals, rate, headerinfo] = readau(file);
    case '.wav' 
      [signals, rate, wmode, fidx] = readwav(file);
    case '.WAV' 
      [signals, rate, wmode, fidx] = readwav(file);
    otherwise
      warning ('unexpected file extension');
      disp(ext)
      return
  end

  dimensions = size(signals);
  channels = dimensions(2);
  if channels ~= 2 
%      warning ('not a stereo file');
  end
  if rate ~= 8000 && rate ~= 16000
    %% higher rates seem to confuse the pitch tracker,
    error('sorry: sampling rate must be 8000 or 16000, not %d\n', rate);
  end
end
  
  


