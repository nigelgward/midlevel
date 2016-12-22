function totalMonster = makeMultiTrackMonster(trackspecs, flist)
  totalMonsterInitialized = false;
  totalMonster = [];

  % for each track 
  for filenum = 1:length(trackspecs)
    trackspec = trackspecs{filenum};
    fprintf('working on features relative to %s channel of "%s" \n', ...
  	   trackspec.side, trackspec.filename);
     tic
     [fvf, trackMonster] = makeTrackMonster(trackspec, flist);
     fprintf('  Time spent making track monster: ');
     toc
     % for PCA purposes, we just throw away incomplete data points
     trackMonster = trackMonster(fvf:end, :);
     [h1, w1] = size(trackMonster);
     [h2, w2] = size(totalMonster);
     fprintf('before vertcat, ');
     fprintf('trackMonster size is %d %d, totalMonster size is %d %d\n', ...
  	   h1, w1, h2, w2);
     if totalMonsterInitialized
       totalMonster = vertcat(totalMonster,trackMonster);
     else 
       totalMonster = trackMonster;
       totalMonsterInitialized = true;
     end
  end
end
     


