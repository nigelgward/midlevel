function writeLoadings(coeff, flist, header, outdir)
  %% sadly this is slow

  lfd = fopen([outdir 'loadings.txt'], 'w');
  fprintf(lfd, '%s\n', header);
  for col = 1:min(30, length(coeff))
    fprintf(lfd, '\n');
    for row = 1:length(coeff)
      fprintf(lfd, 'dimension%d  %5.2f  %s\n', ...
	      col, coeff(row,col), flist(row).abbrev);
    end
  end
  fclose(lfd);
end
