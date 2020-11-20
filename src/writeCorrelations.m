function writeCorrelations(cmatrix, featurelist, outdir, filename);
  
  %% Nigel Ward, University of Texas at El Paso, 2015
  %%
  %% Tool for finding key information in a correlation matrix.
  %% For each feature, shows the other features that correlate well
  %%   with it, and one that is pretty much uncorrelated.
  %% sample use: 
  %%   cmatrix = corrcoef(fetch_and_preen('toyFiles/dummyFileList.fnl'));
  %%   [junk featurelist] = getfeaturespec('toyFiles/dummyCrunchSpech.txt');
  %%   writeCorrelations(cmatrix, featurelist, './', 'tmpCorr.txt');
  
  fd = fopen([outdir filename], 'w');
  
  if length(cmatrix) < 4
    fprintf('writeCorrelations: skipping this since too few features\n');
    return
  end
  
  for columni = 1:length(cmatrix)
    [sortedValues,sortIndex] = sort(cmatrix(columni,:), 'descend');
    topIndices = sortIndex(1:4);
    bottomIndex = sortIndex(length(cmatrix));

    fprintf(fd, 'for feature #%d %s, ', columni, getAbbreviation(featurelist, columni));
    fprintf(fd, '   the three most correlated features are ');
    for ix = 1:4
      topf = topIndices(ix);
      fprintf(fd, '\n     #%d %s   at %.2f', ...
              topf, getAbbreviation(featurelist,topf), cmatrix(columni,topf));
    end
    fprintf(fd, '\n   the most anti-correlated feature is: ');
    bx = bottomIndex;
    fprintf(fd, '\n       #%d %s    at %.2f\n', ...
	    bx, getAbbreviation(featurelist, bx), cmatrix(columni,bx));
  end 
  fclose(fd);
end

function abbrevString = getAbbreviation(featurelist, index)
  cell = featurelist(7, 1, index);
  abbrevString = cell{1};
end

