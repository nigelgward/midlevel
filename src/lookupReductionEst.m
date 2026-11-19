function[estimates, centers] = ...
	lookupReductionEst(directory, auFilename, track)

  %% Return a vector of reduction estimates and a vector of where they are, in ms.
  %% Called by makeTrackMonster.
  %% Derived from lookupOrComputePitch
  %% The estimates are created by running a version of sampleDriver.py
  %%  in the ISG-reduction-model distribution
  %%  and copying the outputs to the reductionE subdirectory
  %%  which is a subdirectory of where the audio files are
  %% The input is every 20ms, starting at 00ms;  output is every 10 ms

  [~, base, extension] = fileparts(auFilename);
    redPathName = [directory, '/reductionE/', base, '-', track, '.txt'];
  if exist(redPathName, 'file') ~= 2
    fprintf(' file not found %s\n', redPathName');
    fprintf(' perhaps need to run the reduction estimator first');
  end 
  stuff = readmatrix(redPathName);    % seems to handle both comma-separated and tab-separated
  estimates = stuff(:,2);
  centers = stuff(:,1);  % not currently used

  %% upsampling
  %  estimates = interp(estimates,2);  %%!! not needed
  return
end
  
%% to test
%%   cd en-social
%%   lookupReductionEst('.', 'utep00.au', 'l');


