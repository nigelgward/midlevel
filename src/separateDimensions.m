function separateDimensions( loadingsFile,outdir )
%parses through loadings.txt file and separates dimension loadings
%into separate files
%Paola Gallardo, UTEP, March 2015

openFile = fopen(loadingsFile);
%%skip header
currLine = fgets(openFile);
%%skip blank space
currLine = fgets(openFile);
%%get first line of data
currLine = fgets(openFile);
%%set up dimension num file
prevDimension = 1;
textFile = sprintf('dimension%.2d.txt',prevDimension);
lfd = fopen([outdir textFile], 'w');

%%traverses entire txt file
while(ischar(currLine))
    %%obtain line of interest (does not include 'dimension')
    currLine = currLine(10:end); 
    splitLine = strsplit(currLine,' ');
    dimension = str2num(splitLine{1});
   %%if not a blank space
   if(~isempty(dimension))
     %%if we're looking at a new dimension, set up new file
     if(dimension~=prevDimension)
        fclose(lfd);
        textFile = sprintf('dimension%.2d.txt',dimension);
        lfd = fopen([outdir textFile], 'w');    
        prevDimension = dimension;
     end
     %%print loading
     fprintf(lfd, '%s %s %s %s %s',splitLine{2},splitLine{3},splitLine{4},splitLine{5},splitLine{6});
  end
   currLine = fgets(openFile);
end
fclose(lfd);
end

