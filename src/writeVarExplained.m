function writeVarExplained(latent)

  varPerDim = latent ./ sum(latent);
  cummulativeVarExplained = cumsum(latent) ./ sum(latent);

  vfd = fopen('variance.txt', 'w');
  header = 'dim  variance cummumative variance\n';
  %%fprintf(header);
  fprintf(vfd, header);
  for dim = 1:min(length(latent), 20)
    line = sprintf('%2d    %5.2f   %5.2f\n', dim, varPerDim(dim), cummulativeVarExplained(dim));
    %%fprintf(line);
    fprintf(vfd, line);
  end
  fclose(vfd);
  %% pareto(latent ./ sum(latent))   % produces a cool graph
end
