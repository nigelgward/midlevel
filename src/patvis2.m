function patvis2(plotTitle, featureVals, featurespecfile, leftedge, rightedge)

% pattern visualization, Nigel Ward, UTEP and Kyoto U
% Janaury 2016.  based on patvis.m, but more flexible

% used for three things, potentially:
% - showing the loadings of all features, for some specific dimension
% - showing the average values of all feature, across 
%   some set of interesting timepoints, for example backchannel onsets
% - showing the values of all raw features (unnormalized and unrotated)
%   at one specific timepoint in a file

% time is on the x axis
% we aggregate all features of a certain type, and draw one line for them
% Bug: can't visually distinguish a feature with value zero over some time
%  and a feature we didn't include in the featurespec over some time

  global interFeatureYOffset;     interFeatureYOffset = 5;
  global leftEdgeMs;              leftEdgeMs = leftedge;
  global rightEdgeMs;             rightEdgeMs = rightedge;

  dustyPurple = [140/256 106/256 186/256];    
  darkGreen  = [127/256 190/256 92/256];     
  mexicanFlagRed = [206/256  17/256  38/256]; 
  mexicanFlagGreen = [  0/256 104/256 71/256];

  featureList = getfeaturespec(featurespecfile);
  if length(featureVals) ~= length(featureList)
    fprintf('patvis2: number of values %d not equal to number of features %d\n', ...
  	  length(featureVals), length(featureList));
  end

  clf;    
  hold on; 

  % this should logically be defined outside this file!
  % side, feature type, label, ybaseline, ygain, color, linestyle
  % note that y = 0 is at the lower left
  plotspec =[{'self'}, {'vo'}, {'Volume'},     105, 10, dustyPurple, {'-'}; ...
	     {'self'}, {'cr'}, {'Creakiness'},  95, 10, dustyPurple, {'-'}; ...
	     {'self'}, {'sr'}, {'S. Rate'},     85, 10, dustyPurple, {'-'}; ...
	     {'self'}, {'ph'}, {'Pitch Height'},75, 10, dustyPurple, {'-'}; ...
	     {'self'}, {'pr'}, {'Pitch Range'}, 65, 10, dustyPurple, {'-'}; ...
	     ...
	     {'inte'}, {'vo'}, {'Volume'},      50, 10, darkGreen, {'-'}; ...
	     {'inte'}, {'cr'}, {'Creakiness'},  40, 10, darkGreen, {'-'}; ...
	     {'inte'}, {'sr'}, {'S. Rate'},     30, 10, darkGreen, {'-'}; ...
	     {'inte'}, {'ph'}, {'Pitch Height'},20, 10, darkGreen, {'-'}; ...
	     {'inte'}, {'pr'}, {'Pitch Range'}, 10, 10, darkGreen, {'-'}; ];


  % NB ygains appropriate for unnormalized feature values are: 
  %  [0.6, 0.3, 5.0, 0.1, 2.4];  

  numberOfLines = size(plotspec,1);
  for f = 1:numberOfLines 
    linespec = plotspec(f,:);
    sidecell = linespec(1);
    side = sidecell{1};
    codecell = linespec(2);
    code = codecell{1};
    labelcell = linespec(3);
    label = labelcell{1};
    ybasecell = linespec(4);
    ybase = ybasecell{1};
    ygaincell = linespec(5);
    ygain = ygaincell{1};
    colorcell = linespec(6);
    color = colorcell{1};
    linestylecell = linespec(7);
    linestyle = linestylecell{1};

    contour = assembleContour(side, code, featureVals, featureList);
    contour = contour * ygain + ybase;
    plotContour(contour, ybase, label, color, linestyle, 2);
  end

  axis([leftEdgeMs rightEdgeMs 0 115]);
  set(gca, 'YTick', []);   % turn off y-axis ticks
  set(gca, 'XTick', [-2000 -1500 -1000 -500  0 500 1000 1500 2000]);
  plot([0 0], [-1000 1000], 'color', [.8 .8 .8]);    % vertical hairline
  xlabel('milliseconds');
  title(plotTitle);
  pbaspect([1.1 1. 1]);
end


% given a feature type, e.g. self volume, returns a vector ready to plot 
function contour = assembleContour(side, code, featureVals, featureList)
   global leftEdgeMs;
   global rightEdgeMs;

   % first handle two special-case codes that don't refer to actual features
   if strcmp(code, 'ph')
     thContour = assembleContour(side, 'th', featureVals, featureList);
     tlContour = assembleContour(side, 'tl', featureVals, featureList);
     contour = thContour - tlContour;
     return 
   end 
   if strcmp(code, 'pr')
     wpContour = assembleContour(side, 'wp', featureVals, featureList);
     npContour = assembleContour(side, 'np', featureVals, featureList);
     contour = wpContour - npContour;
     return 
   end 

   contourLength = rightEdgeMs - leftEdgeMs;
   contour = zeros(contourLength+1, 1);    % a point every millisecond

  % extract information from all features that match this code
  for i = 1:length(featureList)
    featurespec = featureList(i);
    if (strcmp(side, featurespec.side) && ...
        strcmp(featureList(i).featname, code))
      startx = featurespec.startms;
      endx =   featurespec.endms;
      value = featureVals(i);
      startShifted = max(-leftEdgeMs + startx, 1);
      endShifted = min(-leftEdgeMs + endx, -leftEdgeMs + rightEdgeMs);
      contour(startShifted:endShifted) = value;
    end 
  end
end


% yposition and contour are both in pixels by this point 
function plotContour(contour, ybase, cLabel, color, lineStyle, linewidth)
    global interFeatureYOffset;
    global leftEdgeMs;
    global rightEdgeMs;
    plot(leftEdgeMs:rightEdgeMs, contour, ...
	 'color', color, 'lineStyle', lineStyle, 'lineWidth', linewidth);
    labelWidth = 960;   % fragile; depends on the aspect ratio
    text(leftEdgeMs - labelWidth, ybase, cLabel);  
    % now create a dotted line to show the 0 level     
    dotXValues = leftEdgeMs:100:rightEdgeMs;
    dotZeros = zeros(1,length(dotXValues));
    dotSizes = ones(1,length(dotXValues));
    scatter(dotXValues, ybase + dotZeros, dotSizes, 'k');
end



% to test 
% patvis2('Test', [0 1 1 0  1 -.5 -.5 1    0 0 1], '../flowtest/minicrunch.fss', ...
%    -2000, 2000);

% or, edit graphPF.m, to call this to  see the values at a specific point
% of a specific audio file 

%  or look at factor weightings on low side of dimension 8
%  load(rotationspec)
%  ?patvis(-1 *coeff(:,8), 'al_corrected.fss', 'dimension 8 low', true);
