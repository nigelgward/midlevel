function writeLoadings(coeff, flist, header, outdir)

lfd = fopen([outdir 'loadings.txt'], 'w');
fprintf(lfd, '%s\n', header);
for col = 1:length(coeff)
   fprintf(lfd, '\n');
   for row = 1:length(coeff)
     fprintf(lfd, 'dimension%d  %.2f  %s\n', ...
	     col, coeff(row,col), flist(row).abbrev);
   end
end
