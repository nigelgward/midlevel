function [rate, signals] = readtracks(file)

%% Given a stereo audio filename 
%%  reads the file and returns two signals 
%% It's best to avoid wav files; since they can cause errors downstream

%% test with [r,s] = readtracks('../flowtest/21d.au')


  [pathstr, name, ext] = fileparts(file);
  try
    switch ext
      case '.au'
	[signals, rate] = audioread(file); % in earlier Matlab versions was readau
      case '.wav' 
	[signals, rate] = audioread(file); % in earlier Matlab versions was readwav
      case '.WAV' 
	[signals, rate] = audioread(file); % in earlier Matlab versions was readwav
      otherwise
	disp(ext)
	warning ('for file %s, unexpected extension %s , so  skipping it', file, ext);
	return
    end
  catch
    warning('problem trying to audioread from file %s; does it exist?\n', file);
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
  
  


