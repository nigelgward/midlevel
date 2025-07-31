function[estimates, centers] = ...
	lookupReductionEst(directory, auFilename, track)

  %% Return a vector of reduction estimates and a vector of where they are, in ms.
  %% Called by makeTrackMonster.
  %% Derived from lookupOrComputePitch
  %% The estimates are created by running a version of sampleDriver.py
  %%  in the ISG-reduction-model distribution
  %%  and copying the outputs to the reductionE subdirectory
  %%  which is a subdirectory of where the audio files are

  redPathName = [directory, '/reductionE/', auFilename(1:end-3), '-', track, '.txt'];
  if exist(redPathName, 'file') ~= 2
    fprintf(' file not found %s\n', redPathName');
    fprintf(' perhaps need to run the reduction estimator first');
  end 
  stuff = readmatrix(redPathName);
  estimates = stuff(:,2);
  centers = stuff(:,1);  % not currently used
  return
end
  
%% to test
%%   cd en-social
%%   lookupReductionEst('.', 'utep00.au', 'l');


