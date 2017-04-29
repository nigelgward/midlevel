function vec = speakingFraction(logEnergy, msPerWindow)

% returns the fraction of time in each window with speech 
% This will correlate highly with the vo (windowEnergy) feature,
%  except that it will be affected less by speech that's quiet or loud

% Nigel Ward, UTEP, Feb 2017

vec = windowize(speakingFrames(logEnergy), msPerWindow);

% test cases:
% speakingFraction([0 0 0 0 5 5 5 5 4 4 4 4 0 0 0 1 1 1 1 1 0 0  0 0 0 0 0 3 3 3 3 5 5 1 0 0 0 ], 20)


%[r,s] = readtracks('../flowtest/21d.au');
% e = computeLogEnergy(s(:,1)', 80);
% sf = speakingFraction(e, 200);
% plot(sf * 0.1, 'g')
% we = windowEnergy(e, 200);
% hold
% plot(we, 'b')
% compare to audio


