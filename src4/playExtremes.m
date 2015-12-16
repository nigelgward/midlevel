function success = playExtremes( audiofile, extremefile )
%allows user to jump through track to listen to extremes in audio file

openExtremesFile = fopen(extremefile);
extremes = [];
extremesTimePoints = []
getLine = fgets(openExtremesFile);
countLine = 1;

%while(ischar(getLine))   
 %   splitLine = strsplit(getLine,' ');
  %  extremes(countLine) = str2double(splitLine(2));
   % extremesTimePoints(countLine) = str2double(splitLine(3));
  %  getLine = fgets(openExtremesFile);
  %  countLine = countLine+1;
%end
[rate, signalPair] = readtrack(audiofile, 'l');

% --- First, compute frame-level features: left track then right track --- 
success = 1;

playerObjL = audioplayer(signalPair(:,1),rate);
playerObjR = audioplayer(signalPair(:,2),rate);

play(playerObjR);


end

