function done  =  ppattern_saif(path,dimension)  
% ppattern.m
% probably short for "plot prosodic pattern"

% Nigel Ward, University of Texas at El Paso
% December 2013, updated with Paola Gallardo, January 2015

%Saiful Abu
%March 2, created to improve plots

%this has to run after findDimensions, and then separateDimensions

% this takes one argument, a filename like 
% isg/speech/ppca/src4/socialDimensions/dimension26.txt
% which has one feature per line
% each line has:
%  a factor loading, 
%  a feature id (not relevant here)
%  a self/other indictator (self/other)
%  a feature-type indicator
%  (vol,sr,cr,lp,hp,fp,np,tp,wp,wrf,wju,wmi,frf,fju,fmi) 
%  a window start time, in ms
%  a window end time, in ms

% To run it automatically to produce a diagram for each dimension
% example:
% for f=i:178
%  ppattern('/home/research/isg/speech/ppca/src4/socialDimensions/',f)
% end

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

%wrf,wju,wmi,frf,fju,fmi

selfrf  = zeros(xspan);
otherrf = zeros(xspan);
selfju  = zeros(xspan);
otherju = zeros(xspan);
selfmi  = zeros(xspan);
othermi = zeros(xspan);



timepoints = zeros(xspan);

% read in data 
getDimension = sprintf('dimension%d.txt',dimension);
filename = [path getDimension];
display(getDimension);
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
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'rf')
      selfrf(frame + xoffset) = frameloading; 
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'ju')
      selfju(frame + xoffset) = frameloading; 
    elseif strcmp(framespeaker,'se') & strcmp(frametype,'mi')
      selfmi(frame + xoffset) = frameloading; 
      
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'vo')
      othervol(frame + xoffset) = frameloading;
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
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'rf')
      otherrf (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'ju')
      otherju (frame + xoffset) = frameloading;
    elseif strcmp(framespeaker,'in') & strcmp(frametype,'mi')
      othermi (frame + xoffset) = frameloading;
      
    else 
      %fprintf('skipping: fs %s, ft %s\n', framespeaker{1}, frametype{1});
    end
  end
end


%%% constants for plotting 
%volgain = 1.6;

% could automatically adjust these to get separation betwen the two plots
%yselfbase = 2.7;
%yotherbase = 1.0;
%pitchgain = 2.5;  % empirically 
ytop =  +5; 
ybottom = -8;

%fastcolor = [0.0 0.0 0.1];
%slowcolor = [1.0 0.5 0.5];



%axis([-3300 +3300 ybottom ytop]);
axis([-3300 +3300 -0.5 0.5]);


hold on 

set(gca,'YTick', []);
featOnes = ones(1,length(timepoints));

%translated points in order to have all features on one plot 
plot(timepoints,featOnes,'k');
plot(timepoints,selfvol,'b');
plot(timepoints,othervol,'m');
featLabel = sprintf('Volume');
text(-3125, 0.2, featLabel);
%comment start
% plot(timepoints,featOnes*4,'k');
% plot(timepoints,selfvol+4,'b');
% plot(timepoints,othervol+4,'m');
% featLabel = sprintf('Volume');
% text(-3125, 4.2, featLabel);


% plot(timepoints,featOnes*3,'k');
% plot(timepoints,selfsr+3,'b');
% plot(timepoints,othersr+3,'m');
% featLabel = sprintf('Speaking Rate');
% text(-3125, 3.2, featLabel);
% 
% plot(timepoints,featOnes*2,'k');
% plot(timepoints,selfcr+2,'b');
% plot(timepoints,othercr+2,'m');
% featLabel = sprintf('Creaky');
% text(-3125, 2.2, featLabel);
% 
% plot(timepoints,featOnes,'k');
% plot(timepoints,selfhp+1,'b');
% plot(timepoints,otherhp+1,'m');
% featLabel = sprintf('High Pitch');
% text(-3125, 1.2, featLabel);
% 
% plot(timepoints,selflp,'b');
% plot(timepoints,otherlp,'m');
% featLabel = sprintf('Low Pitch');
% text(-3125, 0.2, featLabel);
% 
% plot(timepoints,featOnes*-1,'k');
% plot(timepoints,selffp-1,'b');
% plot(timepoints,otherfp-1,'m');
% featLabel = sprintf('Flat Pitch');
% text(-3125, -0.8, featLabel);
% 
% plot(timepoints,featOnes*-2,'k');
% plot(timepoints,selfnp-2,'b');
% plot(timepoints,othernp-2,'m');
% featLabel = sprintf('Narrow Pitch');
% text(-3125, -1.8, featLabel);
% 
% plot(timepoints,featOnes*-3,'k');
% plot(timepoints,selftp-3,'b');
% plot(timepoints,othertp-3,'m');
% featLabel = sprintf('Typical Pitch');
% text(-3125, -2.8, featLabel);
% 
% plot(timepoints,featOnes*-4,'k');
% plot(timepoints,selfwp-4,'b');
% plot(timepoints,otherwp-4,'m');
% featLabel = sprintf('Wide Pitch');
% text(-3125, -3.8, featLabel);
% 
% plot(timepoints,featOnes*-5,'k');
% plot(timepoints,selfrf-5,'b');
% plot(timepoints,otherrf-5,'m');
% featLabel = sprintf('RF');
% text(-3125, -4.8, featLabel);
% 
% plot(timepoints,featOnes*-6,'k');
% plot(timepoints,selfju-6,'b');
% plot(timepoints,otherju-6,'m');
% featLabel = sprintf('JU');
% text(-3125, -5.8, featLabel);
% 
% plot(timepoints,featOnes*-7,'k');
% plot(timepoints,selfmi-7,'b');
% plot(timepoints,othermi-7,'m');
% featLabel = sprintf('MI');
% text(-3125, -6.8, featLabel);

%comment end

plotlabel = sprintf('Dimension %d', dimension);

text(-500, 4.8, plotlabel);
hold off


end
