% pattern visualization helper function
% Nigel Ward, UTEP, December 2016.  based on old patvis2.m

% input:
%   side is 'self' or 'inte'
%   fcode is the feature to plot, e.g. vo or th

function assembleAndPlotContour(side, fcode, featureVals, featureList, ...
				ybase, ygain, label, color, linestyle)
  contour = assembleContour(side, fcode, featureVals, featureList);
  contour = contour * ygain + ybase;
  plotContour(contour, ybase, label, color, linestyle, 2, -4000, +4000);
end  



function reshapeAndDecorate(leftEdgeMs, rightEdgeMs, plotTitle);
  axis([leftEdgeMs rightEdgeMs -10 125]); % shouldn't be hardfcoded
  set(gca, 'YTick', []);   % turn off y-axis ticks
  set(gca, 'XTick', [-2000 -1500 -1000 -500  0 500 1000 1500 2000]);
  plot([0 0], [-1000 1000], 'color', [.8 .8 .8]);    % vertical hairline
  xlabel('milliseconds');
  title(plotTitle);
  pbaspect([1.1 1. 1]);
end


% given a feature type, e.g. self volume, returns a vector ready to plot 
function contour = assembleContour(side, fcode, featureVals, featureList)
		  % overestimate of the min/max offsets in featureList
  leftEdgeMs = -4000;   
  rightEdgeMs = +4000;

   % first handle three special-case fcodes that don't refer to actual features
   if strcmp(fcode, 'ph')  % pitch height 
     thContour = assembleContour(side, 'th', featureVals, featureList);
     tlContour = assembleContour(side, 'tl', featureVals, featureList);
     contour = thContour - tlContour;
     return 
   end 
   if strcmp(fcode, 'pr')  % pitch range 
     wpContour = assembleContour(side, 'wp', featureVals, featureList);
     npContour = assembleContour(side, 'np', featureVals, featureList);
     contour = wpContour - npContour;
     return
   end
   if strcmp(fcode, 'ap')  % articulatory precision
     enContour = assembleContour(side, 'en', featureVals, featureList);
     reContour = assembleContour(side, 're', featureVals, featureList);
     contour = enContour - reContour;
     return 
   end 

   contourLength = rightEdgeMs - leftEdgeMs;
   contour = zeros(contourLength+1, 1);    % a point every millisecond

	 % extract information from all features that match this fcode
  for i = 1:length(featureList)
    featurespec = featureList(i);
    if (strcmp(side, featurespec.side) && ...
        strcmp(featureList(i).featname, fcode))
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
function plotContour(contour, ybase, cLabel, color, lineStyle, linewidth, ...
		     leftEdgeMs, rightEdgeMs)
    plot(leftEdgeMs:rightEdgeMs, contour, ...
	 'color', color, 'lineStyle', lineStyle, 'lineWidth', linewidth);
    labelWidth = 960;   % fragile; depends on the aspect ratio
    text(-2250, ybase, cLabel);  
    % now create a dotted line to show the 0 level     
    dotXValues = leftEdgeMs:100:rightEdgeMs;
    dotZeros = zeros(1,length(dotXValues));
    dotSizes = ones(1,length(dotXValues));
    scatter(dotXValues, ybase + dotZeros, dotSizes, 'k');
end


