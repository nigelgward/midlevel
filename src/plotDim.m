%% for now, run it from istyles/code

function plotDim(dim, startSec, endSec, drawBoundsp)

  trackspecfile =  'onetrack.tl';
  featuresetfile = 'c:/nigel/midlevel/flowtest/pbook.fss';

  load '../code/rotationspec.mat';   % for nmeans, nstds, coeff, provenance
  
  tracklist = gettracklist(trackspecfile);
  trackspec = tracklist{1};
  featurelist = getfeaturespec(featuresetfile);

  clf;
  hold on;
  [signals, rate] = audioread(trackspec.path);
  startSample = max(1, startSec * rate);
  endSample   = endSec * rate;
  samplesTimeline = 1.0 * (startSample:endSample) / rate;
  samplesTimeline = samplesTimeline(1:length(signals(1:rate*30,1))); % truncate, may be  off-by-one
  plot(samplesTimeline, 2.5 * signals(1:rate*30,1) + 6.5);
  plot(samplesTimeline, 2.5 * signals(1:rate*30,2) + 4.5);
  text(31, 6.5, 'left signal');
  text(31, 4.5, 'right signal');

  rotated = normrotoneAblations(trackspec, featurelist, nmeans, nstds, coeff, 'plotDim', '/tmp/', '/tmp/');

  startFrame = max(1, startSec*100);
  endFrame = endSec*100;
  framesTimeline = (startFrame:endFrame) / 100.0;
  contour = rotated(startFrame:endFrame, dim);
  stdev = std(rotated(:,dim));    % just illustrative; std really should be over a corpus
  contour = contour / stdev;

  plot(framesTimeline, contour, 'LineWidth', 2);
  plot(framesTimeline, zeros(length(framesTimeline), 1), 'Color', [0, 0, 0]);
  xlim([0,37]);
  if drawBoundsp
    intervals = intervalsForCSP();
    bounds = intervals(2:end, 1)';
    for bound = bounds
      plot(framesTimeline, bound * ones(length(framesTimeline), 1), 'Color', [.5 .5 .5]);
      lineLabel = sprintf('%4.1f std', bound);
      text(31, bound, lineLabel);
    end

    %% this function defined in istyles/code; not truly needed for the main plotting
    binCounts = computeDistributionStats(dim, contour, 1);
    binTextYs = [-2.9 -1.9 -.9 0.0 .9 1.9 2.9];
    for i = 1:length(binCounts)
      binCountString = sprintf('%2.0f%%', 100 * binCounts(i));
      text(35, binTextYs(i), binCountString);
    end
  else
    %% not too cluttered, so add an overall label
    titleLike = sprintf('Prosodic Dimension %d', dim)
    text(1, 2.6, titleLike);
  end

  xlabel('seconds');
  set(gca, 'YTick', []); % suppress y labels and gridlines 
end
  
