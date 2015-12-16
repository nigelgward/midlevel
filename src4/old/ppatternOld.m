function done  =  ppattern(dimension, side)  % side is -1 or +1
% ppattern.m
% probably short for "plot prosodic pattern"

% Nigel Ward, University of Texas at El Paso
% December 2013, updated with Paola Gallardo, January 2015

%this has to run after findDimensions, and then separateDimensions

% this takes one argument, a filename like 
% isg/speech/timelm/switchboardPCx/factorLoadings/sorted26.txt
% which has one feature per line
% each line has:
%  a factor loading, 
%  a feature id (not relevant here)
%  a self/other indictator (self/other)
%  a feature-type indicator (VO,SR, PH, PR) (PR is ignored)
%  a window start time, in ms
%  a window end time, in ms

% To run it automatically to produce a diagram for each dimension
% for f=i:76
%  for s=-1:2:+1
%   ppattern(f,s)
%  end
% end
% Then put them on my website under  http://www.cs.utep.edu/nigel/dimensions/

% highest and lowest observed loadings for each feature types
volmax = 0.44;
volmin = -.44;
ratemax = .54;
ratemin =-.54;
pitchmax = .64;
pitchmin =-.64;
% the farthest-offset volume feature is to 3150, and pitch to 4650
xmax = 4650;
xmin = -4650;

ylim([-2 2]);  % y range
clf;     % clear figure

xspan = (xmax - xmin) / 10 + 10;   % add 10 as a safety margin
xoffset = xspan / 2;

% set defaults so that when there is no data, value is 0 (= median)
selfvol = zeros(xspan);
othervol = zeros(xspan);
%selfph  = zeros(xspan);
%otherph = zeros(xspan);
selfsr  = zeros(xspan);
othersr = zeros(xspan);
selfcr  = zeros(xspan);
othercr = zeros(xspan);
selflp  = zeros(xspan);
otherlp = zeros(xspan);
selfhp = zeros(xspan);
otherhp = zeros(xspan);
selffp  = zeros(xspan);
otherfp = zeros(xspan);
selfnp  = zeros(xspan);
othernp = zeros(xspan);
selftp  = zeros(xspan);
othertp = zeros(xspan);
selfwp  = zeros(xspan);
otherwp = zeros(xspan);


timepoints = zeros(xspan);

% read in data 
%filename = sprintf('l:/isg-speech/timelm/switchboardPCx/factorLoadings/sorted%d.txt', dimension);
%filename = sprintf('/home/research/isg/speech/ppca/src4/dimensions/dimension%d.txt',dimension);
filename = sprintf('/home/research/isg/speech/saif/pca/dimensions/dimension%d.txt',dimension);
%filename = sprintf('sorted%d.txt', dimension);
content = importdata(filename);

nfeatures = length(content.data);
startms = content.data(:,1);
endms = content.data(:,2);
loading = content.textdata(:,1);
speaker = content.textdata(:,2);
ftype = content.textdata(:,3);

xrange = xmin/10:xmax/10;
  

for i = 1:length(timepoints)
    timepoints(i) = 10 * (i - xoffset);
    end

% for every feature in the file
for i = 1:length(content.data)
  startframe = startms(i)/10;
  endframe = endms(i)/10;
  frameloading = str2double(loading(i));
  framespeaker = speaker(i);
  frametype = ftype(i);
  % for every frame that is within the scope of that feature
  for frame = startms(i)/10:endms(i)/10
    if strcmp(framespeaker,'se') & strcmp(frametype,'vo')
      selfvol(frame + xoffset) = frameloading;
   % elseif strcmp(framespeaker,'self') & strcmp(frametype,'PH')
   %   selfph (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'sr')
      selfsr(frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'cr')
      selfcr(frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'lp')
      selflp(frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'hp')
      selfhp(frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'fp')
      selffp(frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'np')
      selfnp(frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'tp')
      selftp(frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'wp')
      selfwp(frame + xoffset) = frameloading;
    
      

    elseif strcmp(framespeaker,'in') & strcmp(frametype,'vo')
      othervol(frame + xoffset) = frameloading;
    %elseif strcmp(framespeaker,'other') & strcmp(frametype,'PH')
    %  otherph (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'sr')
      othersr (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'cr')
      othercr (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'lp')
      otherlp (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'hp')
      otherhp (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'fp')
      otherfp (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'np')
      othernp (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'tp')
      othertp (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'wp')
      otherwp (frame + xoffset) = frameloading;
      
    else 
      %fprintf('skipping: fs %s, ft %s\n', framespeaker{1}, frametype{1});
    end
  end
end


if side == -1
   selfvol = -selfvol;
  %selfph = -selfph;
   selfsr = -selfsr;
   selfcr = -selfcr;
   selflp = -selflp;
   selfhp = -selfhp;
   selffp = -selffp;
   selfnp = -selfnp;
   selftp = -selftp;
   selfwp = -selfwp;
   othervol = -othervol;
  %otherph = -otherph;
   othersr = -othersr; 
   othercr = -othercr;
   otherlp = -otherlp;
   otherhp = -otherhp;
   otherfp = -otherfp;
   othernp = -othernp;
   othertp = -othertp;
   otherwp = -otherwp;
end

%%% constants for plotting 
volgain = 1.6;

% could automatically adjust these to get separation betwen the two plots
yselfbase = 2.7;
yotherbase = 1.0;
pitchgain = 2.5;  % empirically 
ytop =  +5; 


fastcolor = [0.0 0.0 0.1];
slowcolor = [1.0 0.5 0.5];


%figuresforpaper = true % make false if producing figures for the website
%if figuresforpaper;
%   fastcolor = [-0.5  0.1 -0.3];
%   slowcolor = [ 1.5  1.2  1.0];
%   ytop=+5.5;
%   pitchgain = 2.1
%   if dimension == 26
%      yselfbase = 3.7;
%      yotherbase = 1.3;  
%   end
%end


axis([-3300 +3300 -5 ytop]);

% more extreme versions; will work except for extreme-rate  patterns 
%fastcolor = [-.2 -.2 -.1];
%slowcolor = [1.5 0.6 0.6];

hold on 

% now compute the drawing parameters by matrix operations

%spitchheight = yselfbase + pitchgain * selfph;
%opitchheight = yotherbase + pitchgain * otherph;

%svolinelen = .01 + volgain * (selfvol - volmin) / (volmax - volmin);
%sylow  = spitchheight - .5 * svolinelen;
%syhigh = spitchheight + .5 * svolinelen;

%ovolinelen = .01 + volgain * (othervol - volmin) / (volmax - volmin);
%oylow  = opitchheight - .5 * ovolinelen;
%oyhigh = opitchheight + .5 * ovolinelen;

%sratefraction = (selfsr  - ratemin) / (ratemax - ratemin);
%oratefraction = (othersr - ratemin) / (ratemax - ratemin); 

%for frame = 1:xspan
%  time = timepoints(frame);
%  sratefraction(frame);
%  scolor = fastcolor * sratefraction(frame) + slowcolor * ( 1 - sratefraction(frame));
%  ocolor = fastcolor * oratefraction(frame) + slowcolor * ( 1 -
%  oratefraction(frame));%

%  rx = [time time+10 time+10 time];
%  ry = [sylow(frame) sylow(frame) syhigh(frame) syhigh(frame)];
%  rs = fill(rx, ry, scolor);
%  set(rs, 'EdgeColor', 'None');

%  rx = [time time+10 time+10 time];
%  ry = [oylow(frame) oylow(frame) oyhigh(frame) oyhigh(frame)];
%  ro = fill(rx, ry, ocolor);
%  set(ro, 'EdgeColor', 'None');

%end

set(gca,'YTick', []);
display(find(selfvol~=0));
featOnes = ones(1,length(timepoints));
%translated points in order to have all features on one plot 
plot(timepoints,featOnes*4,'k');
plot(timepoints,selfvol+4,'o');
plot(timepoints,othervol+4,'m');
featLabel = sprintf('Volume');
text(-3125, 4.2, featLabel);
 
plot(timepoints,featOnes*3,'k');
plot(timepoints,selfsr+3,'b');
plot(timepoints,othersr+3,'m');
featLabel = sprintf('Speaking Rate');
text(-3125, 3.2, featLabel);

plot(timepoints,featOnes*2,'k');
plot(timepoints,selfcr+2,'b');
plot(timepoints,othercr+2,'m');
featLabel = sprintf('Creaky');
text(-3125, 2.2, featLabel);

plot(timepoints,featOnes,'k');
plot(timepoints,selfhp+1,'b');
plot(timepoints,otherhp+1,'m');
featLabel = sprintf('High Pitch');
text(-3125, 1.2, featLabel);

plot(timepoints,selflp,'b');
plot(timepoints,otherlp,'m');
featLabel = sprintf('Low Pitch');
text(-3125, 0.2, featLabel);

plot(timepoints,featOnes*-1,'k');
plot(timepoints,selffp-1,'b');
plot(timepoints,otherfp-1,'m');
featLabel = sprintf('Flat Pitch');
text(-3125, -0.8, featLabel);

plot(timepoints,featOnes*-2,'k');
plot(timepoints,selfnp-2,'b');
plot(timepoints,othernp-2,'m');
featLabel = sprintf('Narrow Pitch');
text(-3125, -1.8, featLabel);

plot(timepoints,featOnes*-3,'k');
plot(timepoints,selftp-3,'b');
plot(timepoints,othertp-3,'m');
featLabel = sprintf('Typical Pitch');
text(-3125, -2.8, featLabel);

plot(timepoints,featOnes*-4,'k');
plot(timepoints,selfwp-4,'b');
plot(timepoints,otherwp-4,'m');
featLabel = sprintf('Wide Pitch');
text(-3125, -3.8, featLabel);


% a white dashed line showing the global 50% pitch
%plot(timepoints, yselfbase + zeros(xspan), '--w');  
%plot(timepoints, yotherbase + zeros(xspan), '--w');  

%plot(timepoints, spitchheight, 'k', 'LineWidth', 2);
%plot(timepoints, opitchheight, 'k', 'LineWidth', 2);

%plot([0 0], [0 ytop ], 'b');      % hairline to mark the origin

if side == -1
  plotlabel = sprintf('Dimension %d Negative', dimension);
  outfile = sprintf('figures/dim%d-neg', dimension);
else
  plotlabel = sprintf('Dimension %d Positive', dimension);
  outfile = sprintf('figures/dim%d-pos', dimension);
end

text(-500, 4.8, plotlabel);
hold off
%figure


end