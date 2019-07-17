% Run DISC without the DISCO GUI. This script will idealize every trace
% in the selected channel.

disc_input = initDISC();

% find and load dataset
if exist('data', 'var')
    loadnew = input('Do you want to load a new data set? y/n [Y]: ','s');
    % unless input is n/N, load new data
    if strcmpi(loadnew, 'N')
        fprintf('Using existing data set ...\n');
    else
        data = loadData();
    end
else
    data = loadData();
end

n_traces = uint32(size(data.rois, 1));
n_channels = uint8(size(data.rois, 2));

% get (or create names)
channel_names = initChannels(data);

% disp all channels and their indices and let user pick index.
fprintf('Please enter the index of the channel you''d like to idealize:\n')
for ii = 1:n_channels
    fprintf('(%u) %s\n', ii, channel_names{ii});
end
ch = uint8(input('> ')); % get channel index from user input

% run DISC on the selected channel
fprintf('Idealizing %s ...\n', channel_names{ch});
tic
reverse_str = ''; % no message will need to be deleted on the first run

for ii = 1:n_traces
    data.rois(ii, ch).disc_fit = runDISC(data.rois(ii, ch).time_series, disc_input);
    % display progress
    progress_msg = sprintf('Idealized %u of %u traces.\n', ii, n_traces);
    fprintf([reverse_str, progress_msg]);
    % construct string to overwrite old progress message using repeated use
    % of  the '\b' ascii character, which indicates a backspace
    reverse_str = repmat(sprintf('\b'), 1, length(progress_msg));
end
toc

save = input('Would you like to save your data? y/n [Y]: ','s');
if strcmpi(save, 'N')
    return
else
    saveData(data);
end
