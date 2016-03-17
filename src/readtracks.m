function [rate, signals] = readtracks(file)
% Given a stereo audio filename 
%  reads the file and returns two signals 
% Best to avoid wav files; they can cause strong problems downstream

% test with readtracks('../minitest/21d.au')

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
      warning ('not a stereo file');
      return
  end

end
  
  


