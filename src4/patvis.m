function patvis(featureVals, featurespecfile, plotname, isLoadings)

% pattern visualization, Nigel Ward, UTEP, April 2015
% If isLoadings is true, shows values as the loadings for a pattern
%  otherwise shows values as the unnormalized and unrotated prosodic
%  features at a specific point in time in an audio file 

% This is called by graphPF, a top-level function, and by diagramDimensions
% It's also designed to be used by other functions, for example
%  to create a visualization of what's happening at points extreme 
%  on some dimension; or to visualize the loadings on a dimension 
%  (to replace visualizeDresden.m)

  global interFeatureYOffset;     interFeatureYOffset = 5;
  global leftEdgeMs;              leftEdgeMs = -2000;
  global rightEdgeMs;             rightEdgeMs = 2000;

  featureList = getfeaturespec(featurespecfile);
  if length(featureVals) ~= length(featureList)
    fprintf('patvis: number of values %d not equal to number of features %d\n', ...
  	  length(featureVals), length(featureList));
  end

  if isLoadings
    yg = 10 * [1, 1, 1, 1, 1];   % ygain 
  else 
    yg = [0.6, 0.3, 5.0, 0.1, 2.4];  % appropriate for unnormalized values
  end

  clf;    
  hold on; 

  for side = 0:1    % self, then interlocutor
    voContour = assembleContour(side, 'vo', featureVals, featureList);
    thContour = assembleContour(side, 'th', featureVals, featureList);
    tlContour = assembleContour(side, 'tl', featureVals, featureList);
    hpContour = assembleContour(side, 'hp', featureVals, featureList); % old
    lpContour = assembleContour(side, 'lp', featureVals, featureList); % old
    wpContour = assembleContour(side, 'wp', featureVals, featureList);
    npContour = assembleContour(side, 'np', featureVals, featureList);
    crContour = assembleContour(side, 'cr', featureVals, featureList);
    srContour = assembleContour(side, 'sr', featureVals, featureList);
    hoContour = hpContour - lpContour; % old;
    phContour = thContour - tlContour; 
    prContour = wpContour - npContour;

    if side == 0     % self 
      lineStyle = '-';    % solid
      color = [140/256 106/256 186/256];     % dusty purple
%      color = [127/256 190/256 92/256];     % dark green 
  %    color = [206/256  17/256  38/256];     % Mexican-flag red
    else % interlocutor
      lineStyle = '--';   % dashed
      color = [127/256 190/256 92/256];     % dark green
%      color = [  0/256 104/256 71/256];     % Mexican-flag green
    end

    ntypes = 5;   % vo, sr, ph, pr, cr
    nplots = ntypes * 2;   % self and interlocutor
    offset = nplots - 1.05 * side * ntypes;
    plotFeature('Volume',      offset - 1, 2, voContour * yg(1), color, lineStyle);
    plotFeature('S. Rate',     offset - 2, 2, srContour * yg(2), color, lineStyle);
      if (sum(phContour) == 0)
    plotFeature('PH Old',      offset - 3, 2, hoContour * yg(3), color, lineStyle);
      else
    plotFeature('Pitch Height',offset - 3, 2, phContour * yg(3), [0 0 0], lineStyle);
      end
    plotFeature('Pitch Range', offset - 4, 2, prContour * yg(4), color, lineStyle);
    plotFeature('Creakiness',  offset - 5, 2, crContour * yg(5), color, lineStyle);
  end   % end for-each side

  axis([leftEdgeMs rightEdgeMs ...
	(-1.0 * interFeatureYOffset) ((0.5 + nplots) * interFeatureYOffset) ]);
  set(gca,'YTick', []);   % turn off y- axis ticks.
%  set(gca, 'XTick', [-2000 -800 -400  0 400 800 2000]);
  set(gca, 'XTick', [-1500 -1000 -500  0 500 1000 1500]);
  plot([0 0], [-1000 1000], 'color', [.8 .8 .8]);    % vertical hairline
  xlabel('milliseconds');
  title(plotname);
end

function contour = assembleContour(side, code, featureVals, featureList)
   global leftEdgeMs;
   global rightEdgeMs;
   contourLength = rightEdgeMs - leftEdgeMs;
   contour = zeros(contourLength+1, 1);    % a point every millisecond
  % extract information from all features that match this code
  for i = 1:length(featureList)
    featurespec = featureList(i);
    if side == 0 && ~strcmp('self', featurespec.side) 
      continue
    end
    if side == 1 && ~strcmp('inte', featurespec.side) 
      continue
    end
    if ~strcmp(featureList(i).featname, code)
       continue
    end
    
    startx = featurespec.startms;
    endx =   featurespec.endms;
    value = featureVals(i);
    startShifted = max(-leftEdgeMs + startx, 1);
    endShifted = min(-leftEdgeMs + endx, -leftEdgeMs + rightEdgeMs);
    %fprintf('assembleContour using %s, value is %.2f\n', featurespec.abbrev, value);
    contour(startShifted:endShifted) = value;
  end
end

function plotFeature(displayName, yposition, width, contour, color, lineStyle)
    global interFeatureYOffset;
    global leftEdgeMs;
    global rightEdgeMs;
    ybase = yposition * interFeatureYOffset;
    contour = contour + ybase; 
    plot(leftEdgeMs:rightEdgeMs, contour, ...
	 'color', color, 'lineStyle', lineStyle, 'lineWidth', width);
    dotXValues = leftEdgeMs:100:rightEdgeMs;
    dotOnes = ones(1,length(dotXValues));
    scatter(dotXValues, ybase * dotOnes, dotOnes,'k');
    text(leftEdgeMs - 870, ybase, displayName);
    pbaspect([1.1 1 1]);
end

% to test
%  patvis([0 1 1 0  1 -.5 -.5 1    0 0 1], '../minitest/minicrunch.fss', 'test plot', true);

%  or invoke via graphPF.m, to see the values at specific points or a specific audio file 

%  or look at factor weightings on low side of dimension 8
%  load(rotationspec)
%  patvis(-1 *coeff(:,8), 'al_corrected.fss', 'dimension 8 low', true);


