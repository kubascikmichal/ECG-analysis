% patient = %%%%%% number of patient %%%%%%;
% filename = ['%%%%%% name of file %%%%%% (' num2str(patient) ')'];

if ~exist('csv', 'dir')
    mkdir('csv');
end

M = load([filename '.mat']);
data = M.val;
data = data(:);
writematrix(data, fullfile('csv/', [filename '.csv']));