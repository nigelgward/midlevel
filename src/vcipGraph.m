% generate the graph for the VCIP paper 
% run vcipGraph.m
% Nigel Ward UTEP, May 2015

% gnpn means gazeOnPredictionOn; gfpf means gazeOffPredictedOff etc
%[gnpn, gfpf, gfpn, gfpf] = gazePredictor;   
% or run that on lisa, save it, and load it just before plotting
%clf; hold;

%----- eventually may be a great graph, but temporarily too dismal
%reduction = mean(gfpf+gnpf);
%usefulSent =  0.89 * gnpn + 0.13 * gfpn;
%usefulTotal = 0.89 * (gnpn + gnpf) + 0.13 * (gfpf + gfpn);
%usefulFraction = usefulSent ./ usefulTotal;

%plot(mean(gfpf + gnpf), 'g');
%mean(reduction)
%plot(1:20, mean(reduction), 'r');
%plot(1:20,  mean(usefulFraction));
%plot(mean(gfpf+gnpf), mean(usefulFraction),'k');
%for i = 1:12
%  plot(gfpf(i,:)+gnpf(i,:), usefulFraction(i,:),'g');
%end

% then overlay the line that we have to beat, namely 
%   usefulFraction = 1 - (1./30 * reduction))
% and the human-predictor point  

%dummy = waitforbuttonpress;  
clf; hold;

plotrange = 1:20;
thresholds = 0.05 * (plotrange - 1)
recall = gfpf ./ (gfpf + gfpn);
precision = gfpf ./ (gfpf + gnpf);
plot(thresholds, mean(precision), 'b.');
plot(thresholds, mean(recall), 'r--');
plot(thresholds, mean((31*precision.*recall ./ (precision + 30*recall))), 'k');
meanprec = mean(precision);
meanrec = mean(recall);
[maxval maxpos] = max(meanprec);
bestrec = meanrec(maxpos);
%bestreduction = reduction(maxpos)

legend('precision', 'recall', 'weighted F-measure');
xlabel('gaze-aversion prediction threshold');

% 1,2 chelsey, nigel hi
% 3 worst (Jesus talking to Paola; very polite)
% 4 Paola high
% 5 Alfonso in love, highest
% 6 Victoria 
% 7 lowish (pilot6.wav, left Caro, non-native)
% 8 moderate Marcus
% 9 moderate Eddie
% 10 lowish Alex
% 11 high (pilot8.wav left Jessica ?)
% 12 highish  (Laura?

for i = 6:6
   plot(thresholds, 31*precision(i,:).*recall(i,:) ./ (precision(i,:) + 30*recall(i,:)), 'g');
end
legend('precision', 'recall', 'weighted F-measure', 'best/worst-predicted speakers');

axis([.21 .79 0 1])

