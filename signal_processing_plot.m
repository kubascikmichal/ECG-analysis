mainDir = pwd;  
allFolders = dir(mainDir);

% find folders
isSubFolder = [allFolders.isdir] & ~ismember({allFolders.name}, {'.', '..'});
subFolders = allFolders(isSubFolder);

% to make the plots with a square form
figure;
nRows = 4;
nCols = 5;

% subplot counter
subplotCounter = 1;

% for each folder, find the first csv file inside the folder csv
for i = 1:length(subFolders)

    subFolderPath = fullfile(mainDir, subFolders(i).name, 'csv');
    csvFiles = dir(fullfile(subFolderPath, '*.csv'));
    
    % if there are csv files, it proccesses the first one or a random one,
    % as decided
    if ~isempty(csvFiles)
        
        % random file instead of the first one
        randomIndex = randi(length(csvFiles));
        csvFilePath = fullfile(csvFiles(randomIndex).folder, csvFiles(randomIndex).name);
        
        % first file found:
        % csvFilePath = fullfile(csvFiles(1).folder, csvFiles(1).name);
        
        data = readmatrix(csvFilePath);
        
        % Downsampling
        factor = 2;  
        data_downsampled = downsample(data, factor);

        fs = 180;  % sampling freq
        subplot(nRows, nCols, subplotCounter);
        spectrogram(data_downsampled, 45, 30, 45, fs, 'yaxis');

        % plot settings
        title(subFolders(i).name);
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        colorbar;

        % subplot counter
        subplotCounter = subplotCounter + 1;
    end
end

% we have less than 4*5 plots so the rest must be empty
for j = subplotCounter:(nRows * nCols)
    subplot(nRows, nCols, j);
    axis off; 
end
