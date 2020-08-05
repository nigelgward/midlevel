%% for now, run it from istyles/code

function plotDim(dim, startSec, endSec)

  trackspecfile =  'onetrack.tl';
  featuresetfile = 'c:/nigel/midlevel/flowtest/pbook.fss';

  load '../code/rotationspec.mat';   % for nmeans, nstds, coeff, provenance
  
  tracklist = gettracklist(trackspecfile);
  trackspec = tracklist{1};
  featurelist = getfeaturespec(featuresetfile);

  rotated = normrotoneAblations(trackspec, featurelist, nmeans, nstds, coeff, 'plotDim', '/tmp/', '/tmp/');

  startFrame = max(1, startSec*100);
  endFrame = endSec*100;
  timeline = (startFrame:endFrame) / 100.0;
  contour = rotated(startFrame:endFrame, dim);
					      
  clf;
  hold on;
  plot(timeline, contour);
  plot(timeline, zeros(length(timeline), 1));
  end
  

  
  

  
  
