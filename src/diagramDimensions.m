function diagramDimensions(rotationspecfile, fssfile)
% makes loadings plots for each dimension and saves them to files
%   in the loadingplots subdirectory of the current directory

% typical call: diagramDimensions('rotationspec.mat');

% In general, there are three use cases
% - creating figures for the book ... instead use figsForBook.m
% - creating figures for perusing, or for the website
% - creating figures for use in a two-column Interspeech paper   

% Nigel Ward,  UTEP, May 2015

  ndims = 12;    
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
     fprintf('warning: overwriting contents of directory "%s"\n', directoryName);
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
%  plotspec = interspeechPlotspec(1.1);
%  plotspec = cppsPlotspec(1.1);
%  plotspec = tiltPlotspec(1.1);   
%    plotspec = pbookPlotspec(1.3);   % for the book
%    plotspec = pbookPlotspec(3.9);   % for the book, dimension 1 ***
%  plotspec = mono4Plotspec(1.1);
%  plotspec = uncompressedSpec(1.0);  % for the book 

  featurespec = getfeaturespec(fssfile);
  for dim = 1:min(ndims,length(coeff))
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
      patvis2(titleString, side * coeff(:,dim), ...
	      featurespec, actualPlotspec, ...
	      -1700, 1700, rotation_provenance);
      nlines = size(actualPlotspec, 1);
      ylim([0 25 + nlines * 15]);    % may need tweaking

      %% improve the x-axis labels
      set(gca, 'fontname', 'Arial');
      set(gca, 'fontsize', 9);
      set(gcf, 'PaperPositionMode', 'auto');
      saveas(gcf, filename, 'png');
      saveas(gcf, filename, 'pdf');
      %%      print(filename, '-dpdf');  % another way to save pdf plots 
    end
  end
end

