% pattern visualization helper function
% Nigel Ward, UTEP, December 2016.  based on old patvis2.m

% input:
%   side is 'self' or 'inte'
%   fcode is the feature to plot, e.g. vo or th

function assembleAndPlotContour(side, fcode, featureVals, featureList, ...
				ybase, ygain, label, color, linestyle, ...
				leftEdgeMs, rightEdgeMs)
  contour = assembleContour(side, fcode, featureVals, featureList, ...
			    leftEdgeMs, rightEdgeMs);
  contour = contour * ygain + ybase;
  plotContour(contour, ybase, label, color, linestyle, 2, ...
	      leftEdgeMs, rightEdgeMs);
end  


% given a feature type, e.g. self volume, returns a vector ready to plot 
function contour = assembleContour(side, fcode, fVals, fList, ...
				  leftms, rightms)

   % first handle three special-case fcodes that don't refer to actual features
   if strcmp(fcode, 'ph')  % pitch height 
     thContour = assembleContour(side, 'th', fVals, fList, leftms, rightms);
     tlContour = assembleContour(side, 'tl', fVals, fList, leftms, rightms);
     contour = thContour - tlContour;
     return 
   end 
   if strcmp(fcode, 'pr')  % pitch range 
     wpContour = assembleContour(side, 'wp', fVals, fList, leftms, rightms);
     npContour = assembleContour(side, 'np', fVals, fList, leftms, rightms);
     contour = wpContour - npContour;
     return
   end
   if strcmp(fcode, 'ap')  % articulatory precision
     enContour = assembleContour(side, 'en', fVals, fList, leftms, rightms);
     reContour = assembleContour(side, 're', fVals, fList, leftms, rightms);
     contour = enContour - reContour;
     return 
   end 

   contourLength = rightms - leftms; 
   contour = zeros(contourLength+1, 1);    % a point every millisecond

	 % extract information from all features that match this fcode
  for i = 1:length(fList)
    featurespec = fList(i);
    if (strcmp(side, featurespec.side) && ...
        strcmp(fList(i).featname, fcode))
      startx = featurespec.startms;
      endx =   featurespec.endms;
      value = fVals(i);
      startShifted = max(-leftms + startx, 1);
      endShifted = min(-leftms + endx, -leftms + rightms);
      contour(startShifted:endShifted) = value;
    end 
  end
end


% yposition and contour are both in pixels by this point 
function plotContour(contour, ybase, cLabel, color, lineStyle, linewidth, ...
		     leftEdgeMs, rightEdgeMs)
    plot(leftEdgeMs:rightEdgeMs, contour, ...
	 'color', color, 'lineStyle', lineStyle, 'lineWidth', linewidth);
    labelWidth = 600;   % in units of milliseconds; odd but works
    text(leftEdgeMs - labelWidth, ybase, cLabel);  
    % now create a dotted line to show the 0 level     
    dotXValues = leftEdgeMs:100:rightEdgeMs;
    dotZeros = zeros(1,length(dotXValues));
    dotSizes = ones(1,length(dotXValues));
    scatter(dotXValues, ybase + dotZeros, dotSizes, 'k');
end


