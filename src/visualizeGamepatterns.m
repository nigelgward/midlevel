function done = ppVisualize( path,dimension )
%PPATTERN_NEW saves the plot of loadings
% input   path is the location for the separated loading files for each dimension
%         dimension is the desired dimension
% output  saves the plot creating a folder, LoadingsVisualization in
% current directory
% created by Nigel Ward and Saiful Abu on March 2015

%debug variable
global APPLY_ALPHA;
APPLY_ALPHA = true;
% each graph is centered at y = -0.1 
global Y_BASE;
Y_BASE = -0.1;
% set gain for x and y axis of plot
% Every value of y of every plot will be multiplied by the y gain. gain of x axis is unused. 
global GAIN
GAIN = [1 2.0];  % was 1.5
global OUTPUT_FORMAT;
% set this variable to get visualization outputs in desired format. Valid
% formats are all valid matlab output figure format. for example, 'png',
% 'jpg', 'fig' etc.
OUTPUT_FORMAT = 'png';
global OUTPUT_DIRECTORY;
OUTPUT_DIRECTORY = '../../../papers/dresden/new-visualizations';  

% th-tl graph is multiplied by TH_TL_GAIN
global TH_TL_GAIN;
TH_TL_GAIN = 1.0;
%for shading jump area we will use MAX_JUMP_LOADING variable
global MAX_JUMP_LOADING;
MAX_JUMP_LOADING = 0.2; %we are considering maximum loading for ju will be 0.2 and minimum will be -0.2
%globally declaring the types of speakers. These values are used to set
%lables of a plot
global SPEAKER_TYPES
SPEAKER_TYPES = {{'se', 'Expert'}, {'in', 'Novice'}};

%globally declaring the features we are going to store. First string is
%used to detect a feature type from the input file. The second string is
%used for labelling the plot.
global FEATURE_TYPES
FEATURE_TYPES = {{'vo', 'Volume'}, {'sr', 'Speaking Rate'}, {'th', 'Hight Pitch'}, {'tl', 'Low Pitch'}, {'rf', 'Running Fraction'}, {'ju', 'Jump'}, {'th-tl', 'Pitch Height'}};

%assigning the colors for both speakers. Red is assigned to expert, green
%is assigned to the novice.
global SPEAKER_COLOR
%SPEAKER_COLOR = ['r' 'g'];
expertColor = [140/256 106/256 186/256];
noviceColor = [157/256 220/256 122/256];
SPEAKER_COLOR = [expertColor; noviceColor];
%SPEAKER_COLOR = [1 0 0; 0 0 1];
% the expert color first, a dusty purple 
% then on top the novice color, a lighter green, with 60% transparency (30% alpha)
% this way, the overlapped regions are a visually distinct grayish purple
% and it looks clearly different in black-and-white too

%alpha of overlapping plots
global ALPHA;
ALPHA = 0.5;

%how many plots we are interested to have. for example if we want the plot
%for volume and speaking rate then number of plots will be 2.
global NUMBER_OF_PLOTS
NUMBER_OF_PLOTS = 6;

%gap between plots
global GAP_BETWEEN_PLOTS
%GAP_BETWEEN_PLOTS = 1;
GAP_BETWEEN_PLOTS = .8;

%setting the axis. 
global AXIS
AXIS = [-2000 2000 -1 ((NUMBER_OF_PLOTS-1) * GAP_BETWEEN_PLOTS)];

%width of the plot in inch
global X_IN_INCH;
X_IN_INCH = 3;
%height of the plot in inch
global Y_IN_INCH;
Y_IN_INCH = 6;

%setting at which locations of x-axis we want ticks.
global X_TICKS
X_TICKS = [-2000 -800 -400  0 400 800 2000];



%load data from the input file
plottingData = loadDataFromFile(path, dimension);

%erase any previous plots
clf(gcf);
%start of plotting
hold on

%setting attributes of axis. 
axis(AXIS); %area of total plot
set(gca,'YTick', []);   % we dont want y axis ticks.
set(gca, 'XTick', X_TICKS);
%set(gcf, 'Position', [250, 250, X_IN_PIXEL Y_IN_PIXEL]);
% %five plots
% for yBase = -1:NUMBER_OF_PLOTS
%     %featureType = yBase + 1;
%     switch yBase
%         case -1
%             featureType = getFeatureType('vo');
%             printLabel(featureType, yBase);                             %plot volume
%             plotBotSpeakers(plottingData, featureType, yBase, true);
%         case 0
%             featureType = getFeatureType('sr');
%             printLabel(featureType, yBase);                             %plot speaking rate
%             plotBotSpeakers(plottingData, 2, yBase, false);  
%         case 1
%             featureType = getFeatureType('th-tl');
%             printLabel(featureType, yBase); 
%             plotBotSpeakers(plottingData, featureType, yBase, false);
%             plottingData{2}{featureType};
%         case 2                                                          %plot rf-ju expert
%             featureType = getFeatureType('rf');
%             speakerType = 1;
%             printLabel(featureType, yBase, speakerType);
%             shadeMultimodalFeats(plottingData, yBase, speakerType);
%             plotArea(plottingData, yBase, speakerType, featureType);
%         case 3                                                          %plot rf-ju novice
%             featureType = getFeatureType('rf');
%             speakerType = 2; 
%             printLabel(featureType, yBase, speakerType);            
%             shadeMultimodalFeats(plottingData, yBase, speakerType);
%             plotArea(plottingData, yBase, speakerType, featureType);
%     end %end of switch case
% end %end of for

%start from y = -1
yReference = 2.6;
for plotNumber = 1: NUMBER_OF_PLOTS
    switch plotNumber
        case 1
            featureType = getFeatureType('vo');
            printLabel(featureType, yReference);                             %plot volume
            plotBotSpeakers(plottingData, featureType, yReference, true);
        case 2
            featureType = getFeatureType('sr');
            printLabel(featureType, yReference);                             %plot speaking rate
            plotBotSpeakers(plottingData, 2, yReference, false);  
        case 3 
            featureType = getFeatureType('hp-lp');
            printLabel(featureType, yReference); 
            plotBotSpeakers(plottingData, featureType, yReference, false);
            plottingData{2}{featureType};
        case 4
            featureType = getFeatureType('rf');
            speakerType = 1;
            printLabel(featureType, yReference, speakerType);
            shadeMultimodalFeats(plottingData, yReference, speakerType);
            plotArea(plottingData, yReference, speakerType, featureType);
        case 5
            featureType = getFeatureType('rf');
            speakerType = 2; 
            printLabel(featureType, yReference, speakerType);            
            shadeMultimodalFeats(plottingData, yReference, speakerType);
            plotArea(plottingData, yReference, speakerType, featureType);
    end
    yReference = yReference - GAP_BETWEEN_PLOTS;
end



%end of plotting
hold off

%save the file
saveFigureFile(dimension);
end
% end of function ppa pattern

%loadDataFromFile loads data from input file. It returns the data retrieved
%form the input file into a cell, plottingData.
%structure of plottingData 
%plottingData
%   expert
%     volume
%        x-values [1    2  3   4    5]
%        y-values [.09 .2 .08  0.8  0.9]
%     speaking rate
%        x-values [1    2  3   4    5]
%        y-values [.09 .2 .08  0.8  0.9]
%     .
%     .
%   novice
%     .
%     . 
                
function plottingData=loadDataFromFile(path, dimension)
    global FEATURE_TYPES;
    global GAIN;
    global TH_TL_GAIN;

    %initialize the variable to be returned, plottingData
    plottingData = cell(2, 1); % first row has self's time point, second row has int's time points
    numberOfFeaturesToConsider = length(FEATURE_TYPES);
    for speakerNumber = 1:2
        plottingData{speakerNumber} = cell(1, numberOfFeaturesToConsider); % we are considering only 6 feature for each speaker
        %initialize each feature points
        for featureNumber = 1:numberOfFeaturesToConsider
            plottingData{speakerNumber}{featureNumber} = zeros(2, 0); % each feature has bunch of x and y points, we will store x in row 1 and y in row2
        end % end of for
    end %end of for 

    %read data to a matrix from a file
    getDimension = sprintf('dimension%d.txt',dimension);
    filename = [path getDimension];
    content = importdata(filename);
    sizeOfDataFile = length(content.data);
    %iterate through each line of input file and store data into plottingData
    for i = 1 : sizeOfDataFile
        featureType = getFeatureType(cell2mat(content.textdata(i,3))); % feature type
        if featureType == -1        %don't do anything for unknown features. 
            continue
        end % end of if
        speakerType = getSpeakerType(cell2mat(content.textdata(i,2))); %speaker
        loadingValue = str2double(content.textdata(i,1)) * GAIN(2); % loading

        startms = content.data(i,1); % start ms
        endms = content.data(i,2); % end ms
        % for the speaker and feature, append x point and corresponding loading in plottindData.
        plottingData{speakerType}{featureType} = [plottingData{speakerType}{featureType} [startms loadingValue]' [endms loadingValue]'];
    end %end of for

    %compute values for th-tl feature for each speaker
    for speakerType = 1:2
        featureIndex = getFeatureType('th-tl');
        thFeatureIndex = getFeatureType('th');
        tlFeatureIndex = getFeatureType('tl');
        xValues = plottingData{speakerType}{thFeatureIndex}(1, :);
        yValues = plottingData{speakerType}{thFeatureIndex}(2, :) - plottingData{speakerType}{tlFeatureIndex}(2, :);
        plottingData{speakerType}{featureIndex} =  [xValues; yValues * TH_TL_GAIN]; % multiply y values with TH_TL_GAIN. otherwise final plot
                                                                                    % shows very small values for th - tl.
    end %end of for
end %end of function


%function to plot both speakers
function done= plotBotSpeakers(plottingData, featureType, yBase, shouldShadeUnderlyingArea)
    for speakerType=1:2        
        if shouldShadeUnderlyingArea == true
            shadeArea(plottingData, yBase, speakerType, featureType);
        end %end if
        plotArea(plottingData, yBase, speakerType, featureType);
    end % end for
end
%end of function

%plots area retrieved from points where yBase is center line
function done = plotArea(plottingData, yBase, speakerType, featureType)
    global GAIN;
    x = plottingData{speakerType}{featureType}(1, :);
    y = plottingData{speakerType}{featureType}(2, :);
    shadingColor = getSpeakerColor(speakerType);
    lineStyle = '-'; %default straight line for expert 
    
    if speakerType == 2
      lineStyle = '--';  % for novice 
    end %end if
    global Y_BASE;
    % darken the outlines
    shadingColor = 0.5 * shadingColor; 
    plot(x, y+yBase-Y_BASE*GAIN(2), 'Color', shadingColor, 'LineStyle', lineStyle); 
    %plot reference point
    %  drawReferenceLine(yBase);
    drawReferenceLine(yBase + .1);
end
%end of function

%write function to color area
%function doneShading = shadeArea(xPoints, yPoints, yBase, color)
function doneShading = shadeArea(plottingData, yBase, speakerType, featureType, color)
	global ALPHA;
    global APPLY_ALPHA;
    xPoints = plottingData{speakerType}{featureType}(1, :);
    yPoints = plottingData{speakerType}{featureType}(2, :);
    color = getSpeakerColor(speakerType);
    for i = 1:2:length(xPoints)
       shadeUnitArea(xPoints(i), xPoints(i+1), yPoints(i)+yBase, yBase, color);
       if APPLY_ALPHA
        alpha(ALPHA);
       end
    end
end
%end of shadeArea function

%function shadeAreaBounded by two points
function done = shadeUnitArea(x1, x2, y1, yBase, color)
    global GAIN;
    global Y_BASE;
    y1 = y1 - Y_BASE * GAIN(2);    
    x = [x1 x2 x2    x1    x1];
    y = [y1 y1 yBase yBase y1];
    areaToShade = area(x, y);
    set(areaToShade, 'FaceColor', color);
    set(areaToShade, 'EdgeColor', 'none');  
end
%end of function shade unit area

%write function to shade jump features
function done = shadeMultimodalFeats(plottingData, yBase, playerType)
    global GAIN;
    global MAX_JUMP_LOADING;
    xPointsRF = plottingData{playerType}{5}(1, :); %x value for running fraction
    yPointsRF = plottingData{playerType}{5}(2, :); %running fraction loading
    yPointsJU = plottingData{playerType}{6}(2, :); %jump loading
    for i = 1:2:length(xPointsRF)
        jumpValue = yPointsJU(i) / GAIN(2); %loading of ju
        %handle cases if the loading is more than the maximum and less than
        %the minimum value
        if jumpValue > MAX_JUMP_LOADING
            jumpValue = MAX_JUMP_LOADING;
        elseif jumpValue < -MAX_JUMP_LOADING
            jumpValue = -MAX_JUMP_LOADING;
        end  %end of if else if
       
        speakerColor = getSpeakerColor(playerType);
        hsl = rgb2hsl(speakerColor);
        adjustedLuminance = hsl(3) + (MAX_JUMP_LOADING - jumpValue) * (0.5 / (2 * MAX_JUMP_LOADING)); % for max_jump_value add to luminance = 0; for -max_jump_value colorFactor = 0.5 
        if adjustedLuminance > 1
            adjustedLuminance = 1;
        end %end if
        hsl(3) = adjustedLuminance;
        color = hsl2rgb(hsl);
        shadeUnitArea(xPointsRF(i), xPointsRF(i+1), yPointsRF(i)+yBase, yBase, color);
    end %end for
    %drawReferenceLine(yBase);
end %end of function

%draw reference line
function done=drawReferenceLine(yBase)
    global AXIS;
    x = [AXIS(1) AXIS(2)];
    y = [yBase yBase];
%    plot(x, y, 'k');    
    plot(x, y, ':k');
end
%end of function

%prints label for a speaker and feature 
function printLabel(featureType, yBase, speakerType)
    global SPEAKER_TYPES;
    global FEATURE_TYPES;
    global AXIS;
    label = FEATURE_TYPES{featureType}{2};
    if(featureType==5 || featureType == 6)
        speakerText = SPEAKER_TYPES{speakerType}{2};
        FeatureText = FEATURE_TYPES{featureType}{2};
        label = sprintf('%s\n%s',speakerText, FeatureText);
    end     %end if else
%    xCordinate = AXIS(1) -500;
    xCordinate = AXIS(1) -660;
    if (featureType == 5 || featureType == 6) % two-line text
      yCordinate = yBase;
    else
      yCordinate = yBase + 0.1;
    end
  text(xCordinate, yCordinate, label);
end %end of function

%function to get speaker type
function speakerType = getSpeakerType(spakerAttribute)
    global SPEAKER_TYPES;
    switch(spakerAttribute)
        case SPEAKER_TYPES{1}{1}
            speakerType = 1;
        case SPEAKER_TYPES{2}{1}
            speakerType = 2;
    end
end
%end of function get speaker type

%function for getting feature type
function featureType = getFeatureType(featureAttribute)
    global FEATURE_TYPES;
    switch(featureAttribute)
        case FEATURE_TYPES{1}{1}
            featureType = 1;
        case FEATURE_TYPES{2}{1}
             featureType = 2;
        case FEATURE_TYPES{3}{1}
             featureType = 3;
        case FEATURE_TYPES{4}{1}
             featureType = 4;
        case FEATURE_TYPES{5}{1}
             featureType = 5;
        case FEATURE_TYPES{6}{1}
             featureType = 6; 
        case FEATURE_TYPES{7}{1}
             featureType= 7;
        otherwise
            featureType = -1;
    end %end of switch case
end %end of fucntion

%function to get the color to use for a speaker
function color = getSpeakerColor(speakerType)
    global SPEAKER_COLOR;
    switch speakerType
        case 1
            color = SPEAKER_COLOR(1, :);
        case 2
            color = SPEAKER_COLOR(2, :);
        otherwise
            color = -1;
    end %end of switch case
end %end of function

%saves output plot to a file
function done = saveFigureFile(dimension)
    global OUTPUT_FORMAT;
    global X_IN_INCH;
    global Y_IN_INCH;
    global OUTPUT_DIRECTORY;
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf,'PaperUnits','inches', 'PaperPosition', [250, 250, X_IN_INCH Y_IN_INCH]);
    directoryName = OUTPUT_DIRECTORY;
    if isdir(directoryName) == false
        mkdir(directoryName);
    end %end of if
    fileName = sprintf('%s/%d', directoryName, dimension);
    saveas(gcf, fileName, OUTPUT_FORMAT);
end
%end of function

%hsl to rgb conversion
function rgb=hsl2rgb(hsl_in)
%Converts Hue-Saturation-Luminance Color value to Red-Green-Blue Color value
%
%Usage
%       RGB = hsl2rgb(HSL)
%
%   converts HSL, a M [x N] x 3 color matrix with values between 0 and 1
%   into RGB, a M [x N] X 3 color matrix with values between 0 and 1
%
%See also rgb2hsl, rgb2hsv, hsv2rgb

% (C) Vladimir Bychkovsky, June 2008
% written using: 
% - an implementation by Suresh E Joel, April 26,2003
% - Wikipedia: http://en.wikipedia.org/wiki/HSL_and_HSV

hsl=reshape(hsl_in, [], 3);

H=hsl(:,1);
S=hsl(:,2);
L=hsl(:,3);

lowLidx=L < (1/2);
q=(L .* (1+S) ).*lowLidx + (L+S-(L.*S)).*(~lowLidx);
p=2*L - q;
hk=H; % this is already divided by 360

t=zeros([length(H), 3]); % 1=R, 2=B, 3=G
t(:,1)=hk+1/3;
t(:,2)=hk;
t(:,3)=hk-1/3;

underidx=t < 0;
overidx=t > 1;
t=t+underidx - overidx;
    
range1=t < (1/6);
range2=(t >= (1/6) & t < (1/2));
range3=(t >= (1/2) & t < (2/3));
range4= t >= (2/3);

% replicate matricies (one per color) to make the final expression simpler
P=repmat(p, [1,3]);
Q=repmat(q, [1,3]);
rgb_c= (P + ((Q-P).*6.*t)).*range1 + ...
        Q.*range2 + ...
        (P + ((Q-P).*6.*(2/3 - t))).*range3 + ...
        P.*range4;
       
rgb_c=round(rgb_c.*10000)./10000; 
rgb=reshape(rgb_c, size(hsl_in));
end 
%end of function

%rgb to hsl function
function hsl=rgb2hsl(rgb_in)
%Converts Red-Green-Blue Color value to Hue-Saturation-Luminance Color value
%
%Usage
%       HSL = rgb2hsl(RGB)
%
%   converts RGB, a M [x N] x 3 color matrix with values between 0 and 1
%   into HSL, a M [x N] X 3 color matrix with values between 0 and 1
%
%See also hsl2rgb, rgb2hsv, hsv2rgb

% (C) Vladimir Bychkovsky, June 2008
% written using: 
% - an implementation by Suresh E Joel, April 26,2003
% - Wikipedia: http://en.wikipedia.org/wiki/HSL_and_HSV

rgb=reshape(rgb_in, [], 3);

mx=max(rgb,[],2);%max of the 3 colors
mn=min(rgb,[],2);%min of the 3 colors

L=(mx+mn)/2;%luminance is half of max value + min value
S=zeros(size(L));

% this set of matrix operations can probably be done as an addition...
zeroidx= (mx==mn);
S(zeroidx)=0;

lowlidx=L <= 0.5;
calc=(mx-mn)./(mx+mn);
idx=lowlidx & (~ zeroidx);
S(idx)=calc(idx);

hilidx=L > 0.5;
calc=(mx-mn)./(2-(mx+mn));
idx=hilidx & (~ zeroidx);
S(idx)=calc(idx);

hsv=rgb2hsv(rgb);
H=hsv(:,1);

hsl=[H, S, L];

hsl=round(hsl.*100000)./100000; 
hsl=reshape(hsl, size(rgb_in));
end
%end of function
