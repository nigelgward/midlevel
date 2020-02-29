function [firstCompleteFrame, monster] = makeTrackMonster(trackspec, featurelist)

% inputs:
%   trackspec: includes au pathname plus track (left or right)
%   fsspec: feature set specification
% output:
%   monster is a large 2-dimensional array, 
  %     where every row is a timepoint, 10ms apart, starting at 10ms (?)
%     and every column a feature
%   firstCompleteFrame, is the first frame for which all data tracks
%     are present.   This considers only the fact that the gaze
%     track may not have values up until frame x
%     It does not consider the fact that some of the wide past-value
%     features may not have meaningful values until some time into the data
%     The reason for this is that, in case the gaze data starts late,
%     we pad it with zeros, rather than truncating the audio.  This is because
%     we compute times using not timestamps, but implicitly, e.g. frame 0 
%     is anchored at time zero (in the audio track)
% efficiency issues: 
%   lots of redundant computation
%   compute everything every 10ms, then in the last step downsample to 20ms
% testing:
%   the simplest test harness is validateFeature.m

% Nigel Ward, UTEP, 2014-2015

plotThings = false;

processGaze = false;
processKeystrokes = false;  
processAudio = false;
firstCompleteFrame = 1;
lastCompleteFrame = 9999999999999;

for featureNum = 1 : length(featurelist)
  thisfeature = featurelist(featureNum);
   if ismember(thisfeature.featname, ['ga', 'gu', 'gd', 'gl', 'gr', 'go'])
       processGaze = true;
   end
   if  ismember(thisfeature.featname, ['rf', 'mi', 'ju'])
	processKeystrokes = true;
   end
   if  ismember(thisfeature.featname, ['vo', 'th', 'tl', 'lp', 'hp', 'fp', 'wp', 'np', 'sr', 'cr', 'pd', 'le', 'vf', 'sf', 're', 'en', 'ts', 'te'])
	processAudio = true;
   end
end

if processGaze 
   [ssl, esl, gzl, gul, gdl, gll, grl, gfl] = ... 
       featurizeGaze(trackspec.path, 'l');
   [ssr, esr, gzr, gur, gdr, glr, grr, gfr] = ...
       featurizeGaze(trackspec.path, 'r');
   firstFullyValidTime = max(ssl, ssr);  % presumably always > 0
   firstCompleteFrame = ceil(firstFullyValidTime * 100);
   lastCompleteFrame = min(length(gzl), length(gzr));
end 

if processKeystrokes 
   [wrf wju wmi] = featurizeKeystrokes(trackspec.path, 'W', 100000);
   [frf fju fmi] = featurizeKeystrokes(trackspec.path, 'F', 100000);
end

  msPerFrame = 10; 

if processAudio 
  % ------ First, compute frame-level features: left track then right track ------
  stereop = decideIfStereo(trackspec, featurelist);
  [rate, signalPair] = readtracks(trackspec.path);
  if size(signalPair,2) < 2 && stereop
    fprintf('%s is not a stereo file, though the feature list ', trackspec.path);
    fprintf('and/or \n the channel in the trackspec suggested it was.  Exiting...\n');
    error('Not Stereo.');
  end
  
  samplesPerFrame = msPerFrame * (rate / 1000);

  signall = signalPair(:,1);
  [plraw, pCenters] = lookupOrComputePitch(...
        trackspec.directory, [trackspec.filename 'l'], signall, rate);
  energyl = computeLogEnergy(signall', samplesPerFrame);
  %%  fprintf('pitch found at %d points\n', sum(plraw > 0)); % not-isNan count
  %%  fprintf('pitch undefined  at %d points\n', sum(isnan(plraw)));

  pitchl = plraw;  
  cepstralFluxl = cepstralFlux(signall, rate, energyl);

  if stereop
    signalr = signalPair(:,2);
    [prraw, pCenters] = lookupOrComputePitch(...
         trackspec.directory, [trackspec.filename 'r'], signalr, rate);
    energyr = computeLogEnergy(signalr', samplesPerFrame);
    cepstralFluxr = cepstralFlux(signalr, rate, energyr);
    [pitchl, pitchr, npoints] = killBleeding(plraw, prraw, energyl, energyr);
    pitchl = pitchl(1:npoints);
    pitchr = pitchr(1:npoints);
    energyl = energyl(1:npoints);
    energyr = energyr(1:npoints);
    cepstralFluxl = cepstralFluxl(1:npoints);
    cepstralFluxr = cepstralFluxr(1:npoints);
  end
  
nframes = floor(length(signalPair(:,1)) / samplesPerFrame);
lastCompleteFrame = min([nframes, lastCompleteFrame, npoints]);

% --- plot left-track signal, for visual inspection ---
if  plotThings
  plotEndSec = 8;  % plot the first few seconds of the signal and featueres
  hold on
  yScalingSignal = .005;
  yScalingEnergy = 6;
  plot(1/rate:1/rate:plotEndSec, signalPair(1:rate*plotEndSec,1)* yScalingSignal);
  % plot pitch, useful for checking for uncorrected bleeding
  pCentersSeconds = pCenters / 1000;
  pCentersToPlot = pCentersSeconds(pCentersSeconds<plotEndSec);
  scatter(pCentersToPlot, pitchl(1:length(pCentersToPlot)), 'g', '.');
  scatter(pCentersToPlot, 0.5 * pitchl(1:length(pCentersToPlot)), 'y', '.'); % halved
  scatter(pCentersToPlot, 2.0 * pitchl(1:length(pCentersToPlot)), 'y', '.'); % doubled
  offset = 0;  
  scatter(pCentersToPlot, pitchr(1:length(pCentersToPlot)) + offset, 'k.');   
  %%plot((1:length(energyl)) * msPerFrame, energyl * yScalingEnergy,'g') 
  xlabel('seconds');
end

maxPitch = 500;
pitchLper = percentilizePitch(pitchl, maxPitch);
if stereop
  pitchRper = percentilizePitch(pitchr, maxPitch);
end

end

% ------ Second, compute derived features, and add to monster ------

for featureNum = 1 : length(featurelist)
  thisfeature = featurelist(featureNum);
  duration = thisfeature.duration;
  startms = thisfeature.startms;
  endms = thisfeature.endms;
  feattype = thisfeature.featname;
  side = thisfeature.side;
  plotcolor = thisfeature.plotcolor;

  if processAudio
    if (strcmp(side,'self') && strcmp(trackspec.side,'l')) || ...
       (strcmp(side,'inte') && strcmp(trackspec.side,'r'))
      relevantPitch = pitchl;
      relevantPitchPer = pitchLper;
      relevantEnergy = energyl;
      relevantFlux = cepstralFluxl;
      relevantSig = signall;
      [lsilenceMean, lspeechMean] = findClusterMeans(energyl);
    else 
      % if stereop is false then this should not be reached 
      relevantPitch = pitchr;
      relevantPitchPer = pitchRper;
      relevantEnergy = energyr;
      relevantFlux = cepstralFluxr;
      relevantSig = signalr;
      [rsilenceMean, rspeechMean] = findClusterMeans(energyr);
    end
  end 

  if processGaze
    if (strcmp(side,'self') && strcmp(trackspec.side,'l')) || ...
	  (strcmp(side,'inte') && strcmp(trackspec.side,'r'))
      relGz = gzl; relGu = gul; relGd = gdl; relGl = gll; relGr = grl; relGa = gfl;
    else
      relGz = gzr; relGu = gur; relGd = gdr; relGl = glr; relGr = grr; relGa = gfr;
    end
  end

  if processKeystrokes
    if (strcmp(side,'self') && strcmp(trackspec.sprite,'W')) || ...
       (strcmp(side,'inte') && strcmp(trackspec.sprite,'F'))
       relevantJU = wju; relevantMI = wmi; relevantRF = wrf;
    else 
       relevantJU = fju; relevantMI = fmi; relevantRF = frf;
    end
  end

%  fprintf('processing feature %s %d %d %s \n', ...
%	  feattype, thisfeature.startms, thisfeature.endms, side); 
    
  switch feattype
    case 'vo'    % volume/energy/intensity/amplitude
      featurevec = windowEnergy(relevantEnergy, duration)';  
    case 'vf'    % voicing fraction
      featurevec = windowize(~isnan([0 relevantPitch' 0]), duration)';
    case 'sf'    % speaking fraction
      featurevec = speakingFraction(relevantEnergy, duration)';
    case 'en'    % cepstral distinctiveness
      featurevec = cepstralDistinctness(relevantSig, rate, relevantPitch, duration, 'enunciation')';
    case 're'    % cepstral blandness
      featurevec = cepstralDistinctness(relevantSig, rate, relevantPitch, duration, 'reduction')';
    case 'th'    % pitch truly high-ness
      featurevec = computePitchInBand(relevantPitchPer, 'th', duration);
    case 'tl'    % pitch truly low-ness
      featurevec = computePitchInBand(relevantPitchPer, 'tl', duration);
    case 'lp'    % pitch lowness 
      featurevec = computePitchInBand(relevantPitchPer, 'l', duration);
    case 'hp'    % pitch highness
      featurevec = computePitchInBand(relevantPitchPer, 'h', duration);
    case 'fp'    % flat pitch range 
      featurevec  = computePitchRange(relevantPitch, duration,'f')';
    case 'np'    % narrow pitch range 
      featurevec  = computePitchRange(relevantPitch, duration,'n')';
    case 'wp'    % wide pitch range 
      featurevec  = computePitchRange(relevantPitch, duration,'w')'; 
    case 'sr'    % speaking rate 
      featurevec = computeRate(relevantEnergy, duration)';
    case 'cr'    % creakiness
      featurevec = computeCreakiness(relevantPitch, duration); 
    case 'pd'    % peakDisalignment
      featurevec = computeWindowedSlips(relevantEnergy, relevantPitchPer, duration,trackspec)';
    case 'le'    % lengthening
      featurevec = computeLengthening(relevantEnergy, relevantFlux, duration);
    case 'vr'    % voiced-unvoiced energy ratio
      featurevec = voicedUnvoicedIR(relevantEnergy, relevantPitch, duration)';

    case 'ts'  % time from start
      featurevec =  windowize(1:length(relevantPitch), duration)';
    case 'te'  % time until end
      featurevec =  windowize((length(relevantPitch) - (1:length(relevantPitch))), duration)';

    case 'ns' % near to start
      featurevec = distanceToNearness(windowize(1:length(relevantPitch), duration)');

    case 'ne' % near to end
      featurevec = distanceToNearness(windowize((length(relevantPitch) - (1:length(relevantPitch))), duration)');

    case 'rf'    % running fraction
      featurevec = windowize(relevantRF, duration)';  % note, transpose
    case 'mi'    % motion initiation
      featurevec = windowize(relevantMI, duration)';  % note, transpose
    case 'ju'    % jumps
      featurevec = windowize(relevantJU, duration)';  % note, transpose

    case 'go'
      if duration == 0          % then we just want to predict it 
        featurevec = relGz(1:end-1)';
      else 
	featurevec = windowize(relGz, duration)'; 
      end 
    case 'gu'
      featurevec = windowize(relGu, duration)';
    case 'gd'
      featurevec = windowize(relGd, duration)';
    case 'gl'
      featurevec = windowize(relGl, duration)';
    case 'gr'
      featurevec = windowize(relGr, duration)';
    case 'ga'
      featurevec = windowize(relGa, duration)'; 

    otherwise
      warning([feattype ' :  unknown feature type']);
  end 
  
  [h, w] = size(featurevec);
  %fprintf('    size of featurevec is %d, %d\n', h, w);

  
% time-shift values as appropriate, either up or down (backward or forward in time)
% the first value of each featurevec represents the situation at 10ms or 15ms
  centerOffsetMs = (startms + endms) / 2;     % offset of the window center
  shift = round(centerOffsetMs / msPerFrame);
  if (shift == 0)
    shifted = featurevec;
  elseif (shift < 0)
    % then we want data from the past, so move it forward in time, 
    % by stuffing zeros in the front 
    shifted = [zeros(-shift,1); featurevec(1:end+shift)];  
  else 
    % shift > 0: want data from the future, so move it backward in time,
    % padding with zeros at the end
    shifted = [featurevec(shift+1:end); zeros(shift,1)];  
  end

  if plotThings && plotcolor ~= 0
     plot(pCentersToPlot, featurevec(1:length(pCentersToPlot)) * 100, plotcolor);
  end 
  % might convert from every 10ms to every 20ms to same time and space,
  % here, instead of doing it at the very end in writePcFilesBis
  %  downsampled = shifted(2:2:end);   
 
  shifted = shifted(1:lastCompleteFrame-1);

  features_array{featureNum} = shifted;  % append shifted values to monster
end   % loop back to do the next feature

monster = cell2mat(features_array);  % flatten it to be ready for princomp

end


% this is tested by calling findDimensions for a small audio file (e.g. short.au)
%  and a small set of features (e.g. minicrunch.fss)
% and then uncommenting various of the "scatter" commands above
%  and examining whether the feature values look appropriate for the audio input


% true if trackspec is a right channel or any feature is inte
function stereop = decideIfStereo(trackspec, featurelist)
  stereop = false;
  if strcmp(trackspec.side, 'r')
    stereop = true;
  end
  for featureNum = 1 : length(featurelist)
    thisfeature = featurelist(featureNum);
    if strcmp(thisfeature.side, 'inte')
      stereop = true;
    end
  end
end


