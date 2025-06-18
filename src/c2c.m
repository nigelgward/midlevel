%% corpus to constructions
%%
%% processes all files in the current directory
%%
%% the feature set used, pbook.fss, etc, 
%%   is located in midlevel/flowtest, which must be added to the path 

function c2c ()
  fssfile = 'pbook.fss';
  fssfile = 'pbookCpps.fss';
  findDimensions('.', fssfile);    % writes correlations and loadings
  diagramDimensions('rotationspec.mat', fssfile);   % creates dimension diagrams
  applynormrot('.', fssfile, '.');   % also writes the extremes 
  load 'rotationspec.mat';
  writeVarExplained(latent);    % writes 
end

  
