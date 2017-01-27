% computeWindowedSlips.m
% Nigel Ward, University of Texas at El Paso and Kyoto University
% January 2016

% Computes a smoothed measure of disalignment between pitch and energy peaks,
%  that is, the "slip" between the pitch and the energy
% Also includes code for plotting things to see how it's being computed
% NB, unlike all the other mid-level features, this one is almost everywhere
%  very near zero

function smoothed = computeWindowedSlips(energy, pitch, duration, trackspec)
    if length(energy) == length(pitch) + 1
      % not sure why this sometimes happens, but just patch it
      energy = energy(1:end-1);
    else if length(energy) ~= length(pitch)
      return;  % if a larger discrepancy, can't patch it
    end
  end

  epeaky = epeakness(energy);
  ppeaky = ppeakness(pitch);

%  [slippage, pulls] = computeSlip(epeaky', ppeaky);
%  smoothedOld = smooth(slippage, rectangularFilter(duration));

  misa = misalignment(epeaky', ppeaky);

     % useful for interpreting the functions of late pitch peak
     % for dimension-based analysis etc. can comment this out
     % flowtestmisalignment.fss is the minimal fss to get this invoked
  writeExtremesToFile('highlyMisaligned.txt', 1000 * misa, ...
			sprintf('%s %s', trackspec.filename, trackspec.side));
 
  smoothed = smooth(misa, rectangularFilter(duration))';
  % plot, useful for debugging and tuning  
  % plotSlips(24000, 30000, energy, pitch, epeaky, ppeaky, misa, smoothed);
end


% (Implementation note: maybe rewrite the other windowization functions
%  to use convolution like this)
% This has the same name as the builtin function smooth; risky
function smoothed = smooth(signal, filter)
  smoothed = conv(signal, filter, 'same');
end


function  plotSlips(startframe, endframe, ...
		    energy, pitch, epeaky, ppeaky, misa, smoothed)
  startframe = max(startframe, 1);
  endframe = min(endframe, length(energy));

  xAxis = startframe:endframe;
  clf
  hold on
  %zoom on
  h = zoom;
  set(h,'Motion','horizontal','Enable','on');
  plot(xAxis, 0.5 * zNormalize(energy(startframe:endframe)) + 5);
  plot(xAxis, 2.0 * pitch(startframe:endframe) + 7);

  plot(xAxis, 4 * epeaky(startframe:endframe) + 12);
  plot(xAxis, 40 * ppeaky(startframe:endframe) + 15.5);

%  plot(xAxis, 400 * slippage(startframe:endframe) + 15);
%  plot(xAxis, 400 * smoothed(startframe:endframe) + 15);

  plot(xAxis, 5000 * misa(startframe:endframe) + 25);
  plot(xAxis, 20000 * smoothed(startframe:endframe) + 25);

%  plot(xAxis, zeros(1,length(xAxis)) + 10); % baseline
%  plot(xAxis, zeros(1,length(xAxis)) + 15); % baseline

%  legend('energy', 'pitch', ...
%	 'epeaky', 'ppeaky', 'slippage', 'smoothed');

% plotIndividualEvidence(xAxis,pulls);
  grid on
  grid minor
end


% time-consuming
function plotIndividualEvidence(xAxis, pulls)
  wholemax = max(max(pulls));
  % this here duplicates code in computeSlip.m; should refactor
  delays = -19:2:20; %minDelay:2:maxDelay;
  for frame = xAxis
     for delayIndex = 1:length(delays)
       delay = delays(delayIndex);
       brightness = 1 - (pulls(delayIndex, frame) / wholemax);  % stronger pulls are darker
       shade = [brightness, brightness, brightness];
	% plot(frame, delay * 0.1, '*');
       plot(frame, delay * 0.1, '.', 'color', shade);
    end
  end 
  plot(xAxis, zeros(1,length(xAxis)) + 0); % baseline
end


function normalized =  zNormalize(signal)
   normalized = signal - mean(signal) / std(signal);
end


