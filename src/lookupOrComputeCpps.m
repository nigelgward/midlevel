%% lookupOrComputeCpps Check if there is cpps data cached for a certain savekey
% and loads it if it exists. If it does not exist, calculates CPPS and
% caches it in the cppsCache folder in directory.
%
%   lookupOrComputeCpps returns:
%       the CPPS data cached at directory/cppsCache/savekey.mat if it
%       exists
%       the CPPS data vector calculated by computeCPPS.m using the signal,
%       s, at the sample rate, samp_freq, if the data cache does not exist.
%       If the data is older than the audo file, then the function will
%       recompute the CPPS data, save it and return it.
%
%   inputs:
%   directory - the directory that holds the audio file.  This is the
%       directory that the cppsCache directory will be created in.
%   savekey - the name of the audio file with the audio channel letter 
%       concatenated to the end.  i.e. 'game_1.wavr'
%   s - the signal data of the audio
%   samp_freq - The sampling rate of the audio signal, in herz.
%       Should be either 8khz or 16khz.

function[CPPS_midlevel] = ...
    lookupOrComputeCpps(directory, savekey, s, samp_freq)
    %% Gets the path for the audio file and cppsCache directory from the parameters
    audioFileName = [directory, savekey(1:end-1)];
    cppsCacheDir = [directory 'cppsCache/'];
    
    %% Checks if the cppsCache directory exists, and creates it if it doesn't
    if ~exist(cppsCacheDir, 'dir')
        mkdir (cppsCacheDir);
    end
    %% Gets the name of the cache file.
    cppsFileName = [cppsCacheDir savekey '.mat'];
    
    %% Checks if the cache does not exist.
    if exist(cppsFileName, 'file') ~= 2
        %% Compute CPPS for the data, then save it.
        % fprintf('computing cpps for %s %s  \n', savekey);
        CPPS_midlevel = computeCPPS(s, samp_freq);
        save(cppsFileName, 'CPPS_midlevel');      
    else
        %% Checks if the cache is older than the audio file
        if file1isOlder(cppsFileName, audioFileName)
            %% Recompute CPPS because the cache file is older than the audio file.
            % fprintf('recomputing cpps for %s %s  \n', savekey);
            CPPS_midlevel = computeCPPS(s, samp_freq);
            save(cppsFileName, 'CPPS_midlevel');     
        %% Here, the cache exists and is up to date.
        else
            %% The cache file exists, load the file.
            % fprintf('reading cached cpps file %s\n', cppsFileName);
            load(cppsFileName)
        end
    end
end
% Function copied from lookupOrComputePitch.m
function isOlder = file1isOlder(file1, file2)
  file1Info = dir(file1);
  file2Info = dir(file2);
  isOlder = file1Info.datenum < file2Info.datenum;
end