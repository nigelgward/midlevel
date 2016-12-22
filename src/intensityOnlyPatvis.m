function intensityOnlyPatvis()
% for the graph in the methodology chapter of the book
% derived from diagramDimensions.m

   % Nigel Ward,  UTEP, May 2015

  hold off
  hold on 
  fcode = 'vo';

  % get coeff, fsspecFile, rotation_provenance, saved earlier by findDimensions
  load('rotationspec.mat')
  fssfile = fsspecFile;
  featurespec = getfeaturespec(fssfile);
  
  dimlist = [1:8 30];
  for dimnum = 1:length(dimlist)
    dim = dimlist(dimnum);
    fprintf('doing dimension %2d\n', dim);
    
    interDimensionSpacing = 30;
    interTrackSpacing = 10;
    ygain = 15;
    ybase = 120 - dimnum * interDimensionSpacing;
    inteYbase = ybase - interTrackSpacing;
    label = sprintf(' %2d: A', dim);
    assembleAndPlotContour('self', fcode, coeff(:,dim), ...
			featurespec, ybase, ygain, label, 'k', '-');
    label = sprintf(' %2d: B', dim);
    assembleAndPlotContour('inte', fcode, coeff(:,dim), ...
			featurespec, inteYbase, ygain, label, 'g', '-');

  end
  reshapeAndDecorate(-1800, +1800, 'intensity-only');
  set(gcf, 'PaperPositionMode', 'auto');
  saveas(gcf, 'intensity-only', 'png');
end


% from patvis2.m
function reshapeAndDecorate(leftEdgeMs, rightEdgeMs, plotTitle);
  bottom = -170;  % shouldn't be hardcoded
  top = 120;
  axis([leftEdgeMs rightEdgeMs bottom top]); 
  set(gca, 'YTick', []);   % turn off y-axis ticks
  set(gca, 'XTick', [-2000 -1500 -1000 -500  0 500 1000 1500 2000]);
  plot([0 0], [-1000 1000], 'color', [.8 .8 .8]);    % vertical hairline
  xlabel('milliseconds');
  title(plotTitle);
  pbaspect([1.1 1. 1]);
end

