function diagramDimensions(rotationspecfile, fssfile)
% makes loadings plots for each dimension and saves them to files
%   in the loadingplots subdirectory of the current directory
% typical call: diagramDimensions('rotationspec.mat');

% Nigel Ward,  UTEP, May 2015

  % get coeff, fsspecFile, rotation_provenance, saved earlier by findDimensions
  load(rotationspecfile);    
  if exist('fsspecFile') 
    fssfile = fsspecFile;
    if nargin > 1 && ~strcmp(fssfile,fsspecFile)
      fprintf('note: using featurespec file from rotationspec, not %s\n', ...
	      fssfile);
    end
  else 
    % then it's a legacy rotationspec file that lacks fsspecFile
    if nargin < 2
       fprintf('please specify a featureset specification file (.fss file)\n');
    % else just use the second argument fssfile as the feature spec
    end 
  end

  directoryName = 'loadingplots';
  if isdir(directoryName) == false
    mkdir(directoryName);
  else
     fprintf('warning: overwriting directory contents\n');
  end 
  provenanceFilename = sprintf('%s/provenance.txt', directoryName);
  sfp = fopen(provenanceFilename, 'w');
  fprintf(sfp, 'plots for %s\n', rotation_provenance);
  fclose(sfp);

  % really this should automatically select, or even generate, an appropriate plotspec
%  plotspec = largePlotspec();  % suitable for largest.fss
%  plotspec = midPlotspec(1.0);    % suitable for midslim.fss
%  plotspec = slim3Plotspec(1.0);    
%  plotspec = midPlotspecSeparate();    % suitable for midslim.fss
%  plotspec = stdPlotspecSeparate();    % suitable for april.fss
%  plotspec = stdPlotspec();    % suitable for april.fss
  plotspec = pbookPlotspec(1.0);   % for the book
  plotspec = mono4Plotspec(1.1); 
%  plotspec = uncompressedSpec(1.0);  % for the book 

  featurespec = getfeaturespec(fssfile);
  for dim = 1:min(14,length(coeff))
    fprintf('doing dimension %2d\n', dim);
    for side =  -1:2:1
      if side == -1
        filename = sprintf('%s/dim%02dlo', directoryName, dim);
    	titleString = sprintf('dimension %2d low', dim);
      else
        filename = sprintf('%s/dim%02dhi', directoryName, dim);
    	titleString = sprintf('dimension %2d high', dim);
      end
      actualPlotspec = plotspec;
%% if uncommented, will generate custom plots for the book
%        actualPlotspec = lookupSpecialPlotspec(dim, side, plotspec);  
      patvis2(titleString, side * coeff(:,dim), ...
	      featurespec, actualPlotspec, ...
	      -1700, 1700, rotation_provenance);
      nlines = size(actualPlotspec, 1);
      ylim([0 260]);    % should be set automatically based on nlines

      set(gcf, 'PaperPositionMode', 'auto');
      saveas(gcf, filename, 'png');
      %% if uncommented, will create pdf plots for the book
      %%      print(filename, '-dpdf');
    end
  end
end

