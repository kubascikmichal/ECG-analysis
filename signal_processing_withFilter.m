close all;
clear all;
mainDir = pwd;  
allFolders = dir(mainDir);

% find folders
isSubFolder = [allFolders.isdir] & ~ismember({allFolders.name}, {'.', '..'});
subFolders = allFolders(isSubFolder);

%%% SPECTROGRAMS
% to make the plots with a square form
figure;
nRows = 4;
nCols = 5;

% subplot counter
subplotCounter = 1;

%%% SIGNAL
figure;
% subplot counter
subplotCounterRaw = 1;

%%% FILTER
% Filter parameters
fs = 180;  % Sampling frequency in Hz
f0_30Hz = 30;   % Center frequency of the first notch filter (30 Hz)
f0_60Hz = 60;   % Center frequency of the second notch filter (60 Hz)
bw = f0_60Hz/35; % Bandwidth around the notch frequencies

% Design notch filters using designfilt
notchFilter_30Hz = designfilt('bandstopiir', 'FilterOrder', 2, ...
    'HalfPowerFrequency1', f0_30Hz-bw, 'HalfPowerFrequency2', f0_30Hz+bw, ...
    'DesignMethod', 'butter', 'SampleRate', fs);

notchFilter_60Hz = designfilt('bandstopiir', 'FilterOrder', 2, ...
    'HalfPowerFrequency1', f0_60Hz-bw, 'HalfPowerFrequency2', f0_60Hz+bw, ...
    'DesignMethod', 'butter', 'SampleRate', fs);

% for each folder, find the first/random csv file inside the folder csv
for i = 1:length(subFolders)

    subFolderPath = fullfile(mainDir, subFolders(i).name, 'csv');
    csvFiles = dir(fullfile(subFolderPath, '*.csv'));
    
    % if there are csv files, it proccesses the first one or a random one,
    % as decided
    if ~isempty(csvFiles)
        
        % random file instead of the first one
        % randomIndex = randi(length(csvFiles));
        % csvFilePath = fullfile(csvFiles(randomIndex).folder, csvFiles(randomIndex).name);
        
        % first file found:
        csvFilePath = fullfile(csvFiles(1).folder, csvFiles(1).name);
        
        data = readmatrix(csvFilePath);
        
        % Apply notch filters
        data_filtered_60Hz = filtfilt(notchFilter_60Hz, data);
        data_filtered = filtfilt(notchFilter_30Hz, data_filtered_60Hz);
        
        % Downsampling
        factor = 2;  
        data_downsampled = downsample(data_filtered, factor);

        fs = 180;  % sampling freq
        
        %%% SPECTROGRAMS
        figure(1);
        subplot(nRows, nCols, subplotCounter);
        spectrogram(data_downsampled, 45, 30, 45, fs, 'yaxis');

        % spectrogram plot settings
        title(subFolders(i).name);
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        colorbar;

        % spectrogram subplot counter
        subplotCounter = subplotCounter + 1;

        %%% SIGNAL
        figure(2);
        subplot(nRows, nCols, subplotCounterRaw);
        plot(data_filtered);

        % signal plot settings
        title(subFolders(i).name);
        xlabel('Samples');
        ylabel('Amplitude');

        % subplot counter for raw signals
        subplotCounterRaw = subplotCounterRaw + 1;
    end
end

% we have less than 4*5 plots so the rest must be empty

%%% SPECTROGRAMS
figure(1);
for j = subplotCounter:(nRows * nCols)
    subplot(nRows, nCols, j);
    axis off; 
end

%%% SIGNAL
figure(2);
for j = subplotCounterRaw:(nRows * nCols)
    subplot(nRows, nCols, j);
    axis off; 
end

fvtool(notchFilter_30Hz, notchFilter_60Hz);

% maybe to erease the line at 30 Hz you can plot the frequency analysis to
% see if the filter is working as it should





% lowpass
% fs_original = 360;  
% cutoff_freq = 8;   

% lpFilt = designfilt('lowpassfir', 'PassbandFrequency', cutoff_freq, ...
%                     'StopbandFrequency', cutoff_freq + 10, ...
%                     'PassbandRipple', 1, ...
%                     'StopbandAttenuation', 60, ...
%                     'DesignMethod', 'kaiserwin', ...
%                     'SampleRate', fs_original);

% data_filtered = filtfilt(lpFilt, data);
