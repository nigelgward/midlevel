% computeWindowedSlips.m
% Nigel Ward, University of Texas at El Paso and Kyoto University
% January 2016

%! for compatibility with the rest of 

function smoothed = computeWindowedSlips(energy, pitch, duration)
  if length(energy) ~= length(pitch)
    %fprintf('computeWindowedSlips: warning: ');
    %fprintf(' lengths not equal; energy %d, pitch %d\n', ...
    %	    length(energy), length(pitch));
    if length(energy) == length(pitch) + 1
      % not sure why this happens, but just patch it
      energy = energy(1:end-1);
    else 
      return;  % if a larger discrepancy, can't patch it
    end
  end

  epeaky = epeakness(energy);
  ppeaky = ppeakness(pitch);

  [slippage, pulls] = computeSlip(epeaky', ppeaky);
  misa = misalignment(epeaky', ppeaky);
  smoothed = smooth(slippage, rectangularFilter(duration));
  smoothed2 = smooth(misa, rectangularFilter(duration));
  % very valuable for debugging and tuning  
  plotSlips(000, 2000000, energy, pitch, epeaky, ppeaky, slippage, smoothed, pulls, misa, smoothed2);
end


% (Implementation note: maybe rewrite the other windowization functions
%  to use convolution like this)
function smoothed = smooth(signal, filter)
  smoothed = conv(signal, filter, 'same');
end


function  plotSlips(startframe, endframe, ...
		    energy, pitch, epeaky, ppeaky, ...
		    slippage, smoothed, pulls,  misa, sm2)
  startframe = max(startframe, 1);
  endframe = min(endframe, length(energy));

  xAxis = startframe:endframe;
  clf
  hold on
  %zoom on
  h = zoom;
  set(h,'Motion','horizontal','Enable','on');
  plot(xAxis, 0.5 * zNormalize(energy(startframe:endframe)) + 5);
  plot(xAxis, 4.0 * pitch(startframe:endframe) + 5);

  plot(xAxis, 4 * epeaky(startframe:endframe) + 10);
  plot(xAxis, 50 * ppeaky(startframe:endframe) + 10);

  plot(xAxis, 400 * slippage(startframe:endframe) + 15);
  plot(xAxis, 400 * smoothed(startframe:endframe) + 15);

  plot(xAxis, 5000 * misa(startframe:endframe) + 25);
  plot(xAxis, 20000 * sm2(startframe:endframe) + 25);

  plot(xAxis, zeros(1,length(xAxis)) + 10); % baseline
  plot(xAxis, zeros(1,length(xAxis)) + 15); % baseline

  legend('energy', 'pitch', ...
	 'epeaky', 'ppeaky', 'slippage', 'smoothed');

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


