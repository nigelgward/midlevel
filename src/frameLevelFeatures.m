function monster = frameLevelFeatures(trackspec)

  %% derived from makeTrackMonster
  %% Nigel Ward, UTEP, June 2017
  
  %% inputs:
  %%   trackspec: specifies audio file pathname plus track (left or right)
  %% output:
  %%   monster is a large 2-dimensional array, 
  %%     where every row is a timepoint, 10ms apart, starting at 10ms (?)
  %%     the columns are pitch-in-hertz and energy (and maybe someday cepstral coefficients)
  %% only handles mono; only handles speech features  
  
  [rate, signalPair] = readtracks(trackspec.path);
  
  msPerFrame = 10;
  samplesPerFrame = msPerFrame * (rate / 1000);

  signall = signalPair(:,1);
  [plraw, pCenters] = lookupOrComputePitch(...
        trackspec.directory, [trackspec.filename 'l'], signall, rate);
  energyl = computeLogEnergy(signall', samplesPerFrame);

  pitchl = [0; plraw];
  monster = [energyl', pitchl];

  %% cepstralFluxl = cepstralFlux(signall, rate, energyl);
end



%% test with
%%  t = makeTrackspec('l', '21d', '../../midlevel/flowtest/');
%%  f = frameLevelFeatures(t);
%%  timestamps = (1:length(f)) * 0.01;
%%  plot(timestamps, f(:,1), .2 * timestamps, f(:,2));
%%  legend('energy', 'pitch');

%% designed to be used with makePPM
