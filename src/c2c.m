%% corpus to constructions
%%
%% processes all audio files in the current directory; for flow testing, this should be flowtest/
%%
%% the feature set used, e.g. pbook.fss
%%   is located in midlevel/flowtest, which must be added to the path 

function c2c ()
  fssfile = 'minicrunch.fss';     %% small; best for testing 
%  fssfile = 'pbook.fss';
%  fssfile = 'pbookCpps.fss';
%    fssfile = 'pbookCppsNas.fss';
%    fssfile = 'pbookCppsRedu.fss';
%    fssfile = 'pbookCppsReduNas.fss';


  findDimensions('.', fssfile);    % writes correlations and loadings
  diagramDimensions('rotationspec.mat', fssfile);   % creates dimension diagrams    
  applynormrot('.', fssfile, '.');   % also writes the extremes 
  load 'rotationspec.mat';
  writeVarExplained(latent);  
end

  
