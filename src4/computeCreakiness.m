function creakValues = computeCreakiness(pitch, windowSizeMs)

% Nigel Ward and Paola Gallardo, December 2014
% Looks for evidence of creak in effects on computed F0, in two ways: 
%  1. the presence of octave jumps and
%  2. the presence of other frame-to-frame pitch jumps (jitter). 
% pitch is a column vector; returns a column vector

framesPerWindow = windowSizeMs / 10;

ratios = pitch(2:end) ./ pitch(1:end-1);

octaveUp = ratios > 1.90 & ratios < 2.10;
octaveDown = ratios > .475 & ratios < .525;
% enormous jumps are probably more due to noise than creaky voice
smallUp = ratios > 1.05  & ratios < 1.25;
smallDown = ratios <  .95 & ratios > .80;

creakiness = octaveUp + octaveDown + smallUp + smallDown;

% creakiness[1] is the creakiness centered at 15ms, 
%  since the first two pitch points are at 10 and 20 ms

integralImage = vertcat([0], cumsum(creakiness));
creakinessPerWindow = integralImage(1+framesPerWindow:end) - ...
                      integralImage(1:end-framesPerWindow) ;

% pad it in front and at end 
% if framesPerWindow is an even number, the first value returned is at 15ms
% if odd, it's at 10ms
headFramesToPad = ceil((framesPerWindow - 1) / 2);
tailFramesToPad = ceil((framesPerWindow ) / 2);
creakArray = vertcat(zeros(headFramesToPad,1), ...
		     creakinessPerWindow, ...
		     zeros(tailFramesToPad,1));
creakValues =  creakArray / framesPerWindow;

% test cases 
% y = [1 1 1 1 1 1 1 1 1 1 1 1 1.1 0.8 1.0 .9 1 1 1 1.01 1.02 1.01 2 1 2 1 .5 .5 .5 1 1 1 1]
% computeCreakiness(y', 50)
% computeCreakiness(y', 30)
% computeCreakiness(y', 100)
