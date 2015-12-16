function [ output_args ] = makeElanPitchLabel( tracklistFile )
% makeElanPitchLabel Creates elan labels from cached pich file
%   Input tracklistFile is the file that contains list of tracks.
%   Output creates a Folder elanTranscription that contains pitch labels
%   for the audio tracks described in the track list file.
%   Sample usage
%   go to /home/research/isg/speech/saif/watergirl
%   run makeElanPitchLabel('justone.tl')
%   After the program stops execution, load the pitch label files to ELAN.
%   !!! This program assumes cached pitch files are already in ./pitchCache
%   folder. 
%   Author Saiful Abu, 5/28/2015 at The University of Texas at El Paso.

msPerFrame = 10;
%windowDurationInMS = 10; %every window is 10 ms long
trackspecs = gettracklist(tracklistFile);
channels = {{'l', 'leftChannel'}; {'r', 'rightChannel'}};  %ELAN tier name
elanTranscriptionFolder = 'elanTranscription';  %folder that contains elan transcription

if ~exist('./pitchCache', 'dir')
  fprintf('No cached pitch file, program will terminate\n');
  return;
end

if exist(elanTranscriptionFolder, 'dir')
    rmdir (elanTranscriptionFolder, 's');
end % end if
mkdir (elanTranscriptionFolder);

for filenum = 1:length(trackspecs)
    trackspec = trackspecs{filenum};
    [rate, ~] = readtracks(trackspec.path);
    %samplesPerFrame = msPerFrame * (rate / 1000);
    msPerSample = 1000 / rate;
    directory = trackspec.directory;
    elanFileName = ['./' elanTranscriptionFolder '/' trackspec.filename(1 : strfind(trackspec.filename, '.') - 1) 'pitch' '.txt'];
    fileId = fopen(elanFileName, 'w');
    %at first look at left channel pitch catche, then right channel pitch
    %cache
    for i = 1:2
        channelName = channels{i}{2};
        savekey = [trackspec.filename channels{i}{1}]; % for now only using l
        pitchFileName = [directory 'pitchCache/pitch'  savekey '.mat'];
        %pitchFileName
        load(pitchFileName);
        startMS = startsAndEnds(:,1) * msPerSample;
        %duration = startsAndEnds(:,2) * msPerSample - startMS;
        %duration = 10;
        for j = 1:length(startMS)
            fprintf(fileId, '%s\t%d\t%d\t%f\n', channelName, startMS(j, 1), (startMS(j, 1) + msPerFrame), pitch(j));
        end %end for
    end %end of for
    fclose(fileId);
    fprintf('finished writing pitch ELAN pitch labels\n');
end %end of for

end %end of function

