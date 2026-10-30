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
  %% the next line was added Oct 2026, based on input from Gus Cooney
  %% to rescale to avoid negative log-energy values, which were messing up the energy-flux computations
  %%   in computeLengthening.m
  %% The change was indirectly verified, by noticing that after this change we got nice positive correlations
  %%   between the lengthening feature and the narrow-pitch and cpps features, over some same-span
  %%  which is plausible, and removed some anti-correlations with other nearby-span  le(lengthening) features
  %%  And by observing that the lengthenings around 19s, 20s and 21s in 21d.zu were clearly seen
signals = signals * 32768;       
end
  
  


