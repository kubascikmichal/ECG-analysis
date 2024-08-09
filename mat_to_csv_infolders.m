addpath 'D:\escritorio files\varios\chambeo\SVK\MLII'

main_folder = 'D:\escritorio files\varios\chambeo\SVK\MLII';
subfolders = dir(main_folder);
subfolders = subfolders([subfolders.isdir] & ~ismember({subfolders.name}, {'.', '..'}));

for i = 1:length(subfolders)

    subfolder_path = fullfile(main_folder, subfolders(i).name);
    output_folder = fullfile(subfolder_path, 'csv');
    
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    mat_files = dir(fullfile(subfolder_path, '*.mat'));

    for k = 1:length(mat_files)

        mat_filename = mat_files(k).name;
        [~, name, ~] = fileparts(mat_filename);

        M = load(fullfile(subfolder_path, mat_filename));
        data = M.val;
        data = data(:);
        writematrix(data, fullfile(output_folder, [name '.csv']));

    end
end