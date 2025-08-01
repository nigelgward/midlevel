%% corpus to constructions
%%
%% processes all files in the current directory
%%
%% the feature set used, e.g. pbook.fss
%%   is located in midlevel/flowtest, which must be added to the path 

function c2c ()
  fssfile = 'pbook.fss';
  fssfile = 'pbookCpps.fss';
  fssfile = 'pbookCppsRedu.fss';
  fssfile = 'pbookCppsReduSlim.fss';  
  findDimensions('.', fssfile);    % writes correlations and loadings
  diagramDimensions('rotationspec.mat', fssfile);   % creates dimension diagrams
  applynormrot('.', fssfile, '.');   % also writes the extremes 
  load 'rotationspec.mat';
  writeVarExplained(latent);  
end

  
