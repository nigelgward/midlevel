function[estimates, centers] = ...
	lookupNasalityEst(directory, auFilename, track)

  %% Return a vector of nasality estimates and a vector of where they are, in ms.
  %% Called by makeTrackMonster.
  %% Derived from lookupReductionE
  %% The estimates are created by running Alan Villamil's nasality detector,
  %%    which is not yet released.
  %%  Those estimeats should be in the nasalityE subdirectory
  %%    which is a subdirectory of where the audio files are
  %% Nasality estimates have a timestamp, left-track-estimate, right-track estimate
  %%   Timestamps are every 20 ms, starting at 12.5ms, which we blithely treat as 00ms

  [~, base, extension] = fileparts(auFilename);
    nasPathName = [directory, 'nasalityE/', base, '.csv'];
  if exist(nasPathName, 'file') ~= 2
    fprintf(' file not found %s\n', nasPathName');
    fprintf(' perhaps need to run the nasality estimator first');
  end 
  stuff = readmatrix(nasPathName);    
  if track == 'l'
    estimates = stuff(:,2);
  else
    estimates = stuff(:,3);
  end
  centers = stuff(:,1);  % not currently used
  %% upsampling
  estimates = interp(estimates,2);
  return
  fprint("size of nasality stuff is %d %d\n", size(stuff));

end
  
%% to test
%%   cd en-social
%%   lookupNasalityEst('.', 'utep00.au', 'l');


