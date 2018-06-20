function patvis2(plotTitle, featureVals, featureList, plotspec, ...
		 leftedge, rightedge, provenance)

%% pattern visualization, Nigel Ward, UTEP and Kyoto U
%% January 2016.  based on patvis.m, but more flexible

%% used for three things, potentially:
%% - showing the loadings of all features, for some specific dimension
%% - showing the average values of all feature, across 
%%   some set of interesting timepoints, for example backchannel onsets
%% - showing the values of all raw features (unnormalized and unrotated)
%%   at one specific timepoint in a file

%% units for leftedge and rightedge are milliseconds

%% time is on the x axis
%% we aggregate all features of a certain type, and draw one line for them

	 % NB ygains appropriate for unnormalized feature values are: 
	 %  [0.6, 0.3, 5.0, 0.1, 2.4];  

  if length(featureVals) ~= length(featureList)
    fprintf('patvis2: number of values %d ~=  number of features %d\n', ...
  	  length(featureVals), length(featureList));
  end

  clf;    
  hold on; 

  numberOfLines = size(plotspec,1);
  for f = 1:numberOfLines 
    [side, fcode, label, ybase, ygain, color, linestyle] = ...
      parseLinespec(plotspec(f,:));
    assembleAndPlotContour(side, fcode, featureVals, featureList, ...
			   ybase, ygain, label, color, linestyle, ...
			   leftedge, rightedge);
  end
  reshapeAndDecorate(leftedge, rightedge, numberOfLines, plotTitle, provenance);
end

    
function [side, fcode, label, ybase, ygain, color, linestyle] = parseLinespec(linespec)
    sidecell = linespec(1);
    side = sidecell{1};
    fcodecell = linespec(2);
    fcode = fcodecell{1};
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
end


function reshapeAndDecorate(leftEdgeMs, rightEdgeMs, numberOfLines, ...
			    plotTitle, provenance);
  headroom = 23;   % better for largePlotspec
  topPixel = numberOfLines * 13 + headroom;
  axis([leftEdgeMs rightEdgeMs 10 topPixel]);
  set(gca, 'YTick', []);   % turn off y-axis ticks
  set(gca, 'XTick', [-2000 -1500 -1000 -500  0 500 1000 1500 2000]);
  plot([0 0], [-1000 topPixel], 'color', [.8 .8 .8]);    % vertical hairline
  xlabel('milliseconds');
  %  title(plotTitle);
  pbaspect([1.1 1. 1]);  % stretch out x-axis by 10%
%  text(leftEdgeMs, -20, provenance, 'FontSize', 8);
end




% to test 
% patvis2('Test', [0 1 1 0  1 -.5 -.5 1    0 0 1], '../flowtest/minicrunch.fss', ...
%    -2000, 2000);

% or, edit graphPF.m, to call this to  see the values at a specific point
% of a specific audio file 

%  or look at factor weightings on low side of dimension 8
%  load(rotationspec)
%  ?patvis2(-1 *coeff(:,8), 'al_corrected.fss', 'dimension 8 low', true);
