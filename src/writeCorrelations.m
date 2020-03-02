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
    
    fCell1 = featurelist(columni);
    fprintf(fd, 'for feature #%d %s, ', columni, fCell1{1});
    fprintf(fd, '   the three most correlated features are ');
    for ix = 1:4
      topf = topIndices(ix);
      fCell2 = featurelist(topf);
      fprintf(fd, '\n     #%d %s   at %.2f', ...
              topf, fCell2{1} , cmatrix(columni,topf));
    end
    fprintf(fd, '\n   the most anti-correlated feature is: ');
    bx = bottomIndex;
    fCell3 = featurelist(bx);
    fprintf(fd, '\n       #%d %s    at %.2f\n', ...
	    bx, fCell3{1}, cmatrix(columni,bx));
  end 
  fclose(fd);
end
