% pattern visualization helper function
% Nigel Ward, UTEP, December 2016.  based on old patvis2.m

% input:
%   side is 'self' or 'inte'
%   fcode is the feature to plot, e.g. vo or th

function assembleAndPlotContour(side, fcode, featureVals, featureList, ...
				ybase, ygain, label, color, linestyle, ...
				leftEdgeMs, rightEdgeMs)
  [contour, startms, endms] = assembleContour(side, fcode, featureVals, featureList, ...
					      leftEdgeMs, rightEdgeMs);
  contour = contour * ygain + ybase;
  plotContour(contour, ybase, label, color, linestyle, 2, ...
	      leftEdgeMs, rightEdgeMs, startms, endms);
end  



% given a feature type, e.g. self volume, returns a vector ready to
% plot
function [contour, firstValidPoint, lastValidPoint] = assembleContour(side, fcode, fVals, fList, ...
		  leftms, rightms)

   % first handle three special-case fcodes that don't refer to actual features
   if strcmp(fcode, 'ph')  % pitch height 
     [thContour, first, last] = assembleContour(side, 'th', fVals, fList, leftms, rightms);
     tlContour = assembleContour(side, 'tl', fVals, fList, leftms, rightms);
     contour = thContour - tlContour;
     firstValidPoint = first;
     lastValidPoint = last; 
     return 
   end 
   if strcmp(fcode, 'pr')  % pitch range 
     [wpContour, first, last] = assembleContour(side, 'wp', fVals, fList, leftms, rightms);
     npContour = assembleContour(side, 'np', fVals, fList, leftms, rightms);
     contour = wpContour - npContour;
     firstValidPoint = first;
     lastValidPoint = last; 
     return
   end
   if strcmp(fcode, 'ap')  % articulatory precision
     [enContour, first, last] = assembleContour(side, 'en', fVals, fList, leftms, rightms);
     reContour = assembleContour(side, 're', fVals, fList, leftms, rightms);
     contour = enContour - reContour;
     firstValidPoint = first;
     lastValidPoint = last; 
     return 
   end 

   contourLength = rightms - leftms; 
   contour = zeros(contourLength+1, 1);    % a point every millisecond

   %% extract information from all features that match this fcode
   firstValidPoint = 0;
   lastValidPoint = 0;
   for i = 1:length(fList)
     featurespec = fList(i);
     if (strcmp(side, featurespec.side) && ...
         strcmp(fList(i).featname, fcode))
       startx = featurespec.startms;
       endx =   featurespec.endms;
       if startx < firstValidPoint
	 firstValidPoint = startx;
       end
       if endx > lastValidPoint
	 lastValidPoint = endx;
       end
       value = fVals(i);
       startShifted = max(-leftms + startx, 1);
       endShifted = min(-leftms + endx, -leftms + rightms);
       contour(startShifted:endShifted) = value;
     end 
   end

end


function plotContour(contour, ybase, cLabel, color, lineStyle, linewidth, ...
		     leftEdgeMs, rightEdgeMs, startms, endms)
    %% create a thin (or dotted) line to show the 0 level     
    plot(leftEdgeMs:rightEdgeMs, ybase+zeros(1+rightEdgeMs-leftEdgeMs,1), ...
	'color', [.5 .5 .5]);

    labelWidth = 740;   % in units of milliseconds; odd but works
    t = text(leftEdgeMs - labelWidth, ybase+1, cLabel);
    t.FontSize = 10;  % was 9
    t.FontName = 'Arial';

    plotRangeStart = 1+max(leftEdgeMs, startms);
    plotRangeEnd   = min(rightEdgeMs, endms);
    rangeToPlot = -leftEdgeMs + (plotRangeStart:plotRangeEnd);

    plot((plotRangeStart:plotRangeEnd), contour(rangeToPlot), ...
	 'color', color, 'lineStyle', lineStyle, 'lineWidth', linewidth);
    plot([plotRangeStart, plotRangeStart], [ybase, contour(-leftEdgeMs+plotRangeStart)], ... 
	 'color', color, 'lineStyle', lineStyle, 'lineWidth', linewidth);
    plot([plotRangeEnd  , plotRangeEnd  ], [ybase, contour(-leftEdgeMs+plotRangeEnd)], ... 
	 'color', color, 'lineStyle', lineStyle, 'lineWidth', linewidth);

end


