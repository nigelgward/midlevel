function ratio = voicedUnvoicedIR(logEnergy, pitch, msPerWindow)
  % compute voiced-unvoiced intensity ratio
  % Nigel Ward, UTEP, February 2017

  % for windows which lack unvoiced frames or lack voiced frames,
  %  return the average value, since we only care about departures
  %  from the norm

  logEnergy = logEnergy';

  if (length(logEnergy) == length(pitch) + 1)
%    fprintf('length(logEnergy) = %d; length(pitch) = %d \n', ...
%	    length(logEnergy), length(pitch));
    pitch = [0; pitch];
  end

  isSpeech = speakingFrames(logEnergy);

  voicedSpeechVec = (~isnan(pitch) & isSpeech);
  unvoicedSpeechVec = (isnan(pitch) & isSpeech);
%  fprintf('sum(voicedSpeechVec) %d, sum(unvoicedSpeechVec) %d\n', ...
%	  sum(voicedSpeechVec), sum(unvoicedSpeechVec));

  nonVoicedEnergiesZeroed = voicedSpeechVec .* logEnergy;
  nonUnvoicedEnergiesZeroed = unvoicedSpeechVec .* logEnergy;

  vFrameCumSum = [0; cumsum(nonVoicedEnergiesZeroed)];
  uFrameCumSum = [0; cumsum(nonUnvoicedEnergiesZeroed)];

  vFrameCumCount = [0; cumsum(voicedSpeechVec)];
  uFrameCumCount = [0; cumsum(unvoicedSpeechVec)];

  framesPerWindow = msPerWindow / 10;
  framesPerHalfWindow = framesPerWindow / 2;

  for i=1:length(pitch)
    wStart =  i - framesPerHalfWindow;
    wEnd = i + framesPerHalfWindow ;
    % prevent out-of-bounds
    if(wStart < 1)
      wStart = 1;
    end
    if(wEnd > length(pitch))
      wEnd = length(pitch);
    end
    vFrameWinSum(i) = vFrameCumSum(wEnd) - vFrameCumSum(wStart);
    uFrameWinSum(i) = uFrameCumSum(wEnd) - uFrameCumSum(wStart);
    vFrameCountSum(i) = vFrameCumCount(wEnd) - vFrameCumCount(wStart);
    uFrameCountSum(i) = uFrameCumCount(wEnd) - uFrameCumCount(wStart);
  end

  avgVoicedIntensity =   vFrameWinSum ./ vFrameCountSum;
  avgUnvoicedIntensity = uFrameWinSum ./ uFrameCountSum;

  ratio = avgVoicedIntensity ./ avgUnvoicedIntensity;
  % exclude zeros, NaNs, and Infs
  averageOfValid = mean(ratio(~isinf(ratio) & ratio>0));
  ratio(ratio==0) = averageOfValid;
  ratio(isnan(ratio)) = averageOfValid;
  ratio(isinf(ratio)) = averageOfValid;

  writeExtremesToFile('highVUIR.txt', ratio, ratio, 'times of high vuir', '  ');
  writeExtremesToFile('lowVUIR.txt', -ratio, ratio, 'times of low vuir',  '  ');

%  clf
%  hold on 
%  plot(1:length(pitch), 100 * isSpeech, ...
%       1:length(pitch), 10 * logEnergy, ...
%       1:length(pitch), pitch, ...
%       1:length(pitch), 100 * ratio);
%    legend('isSpeech', 'logEnergy', 'pitch', 'v-uv i ratio');
end

% test data
%   silence energy around 1, voiced around 9,
% quiet unvoiced around 5, loud unvoiced around 7

% testdata set 1 represents silence then a vowel
% testdata set 2 represents an quiet unvoiced consonant then a vowel 
% testdata set 3 represents silence then a loud unvoiced consonant

%p1 = [5 NaN    5 NaN 6 NaN NaN NaN NaN 7 8 7 7 1 3 2 8 3 9 NaN];
%e1 = [1   1    0   1 0   1   0  2    0 9 9 8 8 9 7 2 9 8 8   8]; 
%p2 = [2 NaN NaN NaN NaN NaN NaN NaN 7 8 7 8 7 8 9 8 9 7];
%e2 = [4   5   4   5   3   5   7   4 8 9 1 8 9 9 8 7 6 9];
%p3 = [2 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN ];
%e3 = [4   0   1   1   2   1   0   1   2   7   8   7   7   7   7 ];

%voicedUnvoicedIr([e1 e2], [p1 p2], 200);  % ratio result should be around 1.8
%voicedUnvoicedIr([e1 e3], [p1 p3], 200);  % ratio result should be around 1.3

% I also "tested" it by running it on 21d and seeing where the value is high/low
% It seemed high during politer regions, and low during self-talk.
