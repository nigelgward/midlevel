function [done] = findMaximumPoints(directory, dimensionIndex)
%findMaximumPoints finds the timepoints where value of dimension
%dimensionIndex is greater than all the other dimensions at that point of
%time
%Input
%   directory - Name of the directory that contains .pc files
%   dimensionIndex - the dimension of interest
%Output   
%   Writes the time point, value of the dimension and Track File name in
%   the MaximumPoints/dimensionIndex.txt file of current working directory.
%
%   It is to be noted that the '.pc' files that this program reads has 
%   one line header, after the header each line has time followed by one
%   column per dimension.
% Saiful Abu, March, 2015

%open output file
fileName = [num2str(dimensionIndex) '.txt'];
OUTPUT_DIRECTORY = 'MaximumPoints';
mkdir(OUTPUT_DIRECTORY);
outputFileId = fopen([OUTPUT_DIRECTORY '/' fileName], 'w');
%output file has been created

%get list of all files in the current directory
listOfFile = dir(directory);

FILE_WRITING_INTERVAL = 1; %write to file if previous time point is more than FILE_WRITING_INTERVAL seconds ago of current time

%check each file, if it has '.pc' extension open it otherwise continue
for inputFileIndex = 1 : size(listOfFile)
    inputFileName = listOfFile(inputFileIndex).name;
    [~, ~, inputFileExtension] = fileparts(inputFileName);
    if(strcmp(inputFileExtension, '.pc') ~= 1)
        continue;
    end %end if
    %open a pc file
    inputFileId = fopen([directory '/' inputFileName]);
    if(inputFileId == -1)
        display('Error reading input file');
        done = false;
        return;
    end %end if
    inputFileContent = textscan(inputFileId, '%s', 'delimiter', '\n');
    numberOfLines = size(inputFileContent{1});
    
    previousTimeWrittenToFile = -1;
    for line = 2 : numberOfLines % skip first line as it is the header
        row = str2num(inputFileContent{1}{line});  %get a line of the input File
        [maximumValue, maximumIndex] = max(row(2:end)); % first column has time information, skip it 
        if(maximumIndex == dimensionIndex)
            time = row(1);
            if((time - previousTimeWrittenToFile) >= FILE_WRITING_INTERVAL) % only write to file if it is after specified 
                stringToWrite = sprintf('time : % 7.2f, value : % 6.2f in %5s\n', time, maximumValue, inputFileName(1:6));
                fprintf(outputFileId, stringToWrite);
                previousTimeWrittenToFile = time;
            end %end if
        end %end if  
    end %end of for
    %close input file
    fclose(inputFileId);
end %end of for

%close output file
fclose(outputFileId);
done = true;

end %end of function

