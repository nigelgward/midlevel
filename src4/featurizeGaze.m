function [firstDataSec, lastDataSec, gz, gu, gd, gl, gr, ga] = ...
    featurizeGaze(audioFilename, channel)

% featurizeGaze, Nigel Ward, April 2015
% Inputs
%   channel is 'l' or 'r', for left or right
% Outputs
%   gz is gaze on/off
%   gu, gd, gl, gr are gaze up/down/left/right, gf is gaze-faceness
%   these are all vector of values every 10 milliseconds
% this is called by makeTrackMonster, in the service of gazePredictor

[path, name, ext] = fileparts(audioFilename);
filename = [path '/' name channel '.csv'];
fprintf(['Reading  gaze from ' filename '\n']);

% only want the first 4 fields.  
contents = csvread(filename, 1, 0);  % skip the one-line header 
startsSec = contents(:,1);
endsSec =   contents(:,2);
fixationx = contents(:,3);
fixationy = contents(:,4);

%t = readtable(filename);   % alas, this function is only in recent Matlab
%startsSec = t.Timestamp;
%endsSec = t.Timestamp_End;
%fixationx = t.X_Coor;
%fixationy = t.Y_coor;   % yes, this one is lower case

% gazeon = contents(:,5);   % Chelsey says this is meaningless
%  xpos is 0 if gaze is at left edge of screen, 1 at right edge 
%  ypos ditto for top and bottom 
%  if x==y==0 then gaze was not detected, so there's no evidence for anything

firstDataSec = startsSec(1);
lastDataSec  = endsSec(end);
%fprintf('  firstDataSec %.2f, lastDataSec %.2f\n', firstDataSec, lastDataSec);

% infer the centerpoint of the likely on-face fixations
centralishx = fixationx(fixationx > .05 & fixationx < .95);
centralishy = fixationy(fixationy > .05 & fixationy < .95);
centralx = mean(centralishx);
centraly = mean(centralishy);
fprintf('  on-screen average position: (%.2f, %.2f)\n', centralx, centraly);

% show the gaze distribution and the computed center
%hold on 
%scatter(fixationx, fixationy, '.','g')
%plot([centralx], [centraly], 'ko','MarkerSize', 9);
%axis([-.2, 1.2, -0.4, 1.8]);

% set up the per-frame vectors
gazex = [];   
gazey = [];
gazeon = [];

% before first valid data point, assume subject is looking at the center
normalizedx = 0;
normalizedy = 0;

for i = 1: length(startsSec)
   startFrame = floor(startsSec(i) * 100);
   endFrame = floor(endsSec(i) * 100);
   fx = fixationx(i);
   fy = fixationx(i);
   validGaze = fx ~= 0 || fy ~= 0;
   if ~validGaze 
     gazeon(startFrame:endFrame) = 0;
     % keep using the most recently computed values
     gazex(startFrame:endFrame) = normalizedx;
     gazey(startFrame:endFrame) = normalizedy;
     continue
   end

   normalizedy = fixationy(i) - centraly;
   % approx a 5:4 aspect ratio, convert to screen-height units
   normalizedx = 1.243 * fixationx(i) - centralx; 
   gazex(startFrame:endFrame) = normalizedx;
   gazey(startFrame:endFrame) = normalizedy;
   distance = sqrt( normalizedx * normalizedx + normalizedy * normalizedy);
   if distance > .70
     gazeon(startFrame:endFrame) = 0;				
   else 
     gazeon(startFrame:endFrame) = 1;
   end 
end

fprintf('  gaze-on percentage = %.3f ( %d / %d)\n', ...
   sum(gazeon) / length(gazeon),  sum(gazeon), length(gazeon));

% gaze-rightness is distance to right of the average-on-screen point, 
% but 0 if in left half, or if no gaze detected
gl = - gazex;
gl(gl<0) = 0;

gr = gazex;
gr(gr<0) = 0;

gu = gazey;
gu(gu<0) = 0;

gd = -gazey;
gd(gd<0) = 0;

gz = gazeon;

% ga is gaze-away distance
ga = sqrt(gazex .* gazex + gazey .* gazey);


%clf
%hold on 
%plot(1:10000, gz(1:10000), 'r');  %gaze on/off
%plot(1:10000, gazex(1:10000), 'k');  
%plot(1:10000, gazey(1:10000), 'g');  

%plot(1:10000, gu(1:10000), 'g');  %gaze up
%plot(1:10000, gd(1:10000), 'b');  %gaze down
%plot(1:10000, gl(1:10000), 'm');  %gaze right
%plot(1:10000, gr(1:10000), 'y');  %gaze left
%axis([-100 10100 -1.5 1.5]);

end