% Run DISC without the DISCO GUI. This script will idealize every trace
% in the selected channel.

global data

% see src_DISC/setDefault.m for more information on the choices here.
% ******************** User modification HERE! ****************************
disc_input.input_type = 'alpha_value';
disc_input.input_value = 0.05;
disc_input.divisive = 'BIC_GMM';
disc_input.agglomerative = 'BIC_GMM';
disc_input.viterbi = 1;
disc_input.return_k = 0;
% ********************* End User modification *****************************

% find and load dataset
if ~isempty(data)
    loadnew = input('Do you want to load a new data set? y/n [Y]: ','s');
    % unless input is n/N, load new data
    if strcmp(loadnew, 'N') || strcmp(loadnew, 'n')
        disp('Using existing data set ...');
    else
        loadData();
    end
else
    loadData();
end

n_channels = size(data.rois, 2);
% name channels if data.names does not exist
if ~isfield(data,'names')
    % create empty field
    data.names = {}; 
    for ii = 1:n_channels
        % assign names based on index
        data.names{ii} = ['Channel ', num2str(ii)];
    end
end

% disp all channels and their indices and let user pick index.
fprintf('Please enter the index of the channel you''d like to idealize:\n')
for ii = 1:n_channels
    fprintf('(%g) %s\n', ii, data.names{ii});
end
ch = input('> '); % get channel index from user input

% run DISC on the selected channel
fprintf('Idealizing %s ...\n', data.names{ch});
tic
reverse_str = ''; % no message will need to be deleted on the first run
num_traces = size(data.rois,1);
for ii = 1:size(data.rois, 1)
    data.rois(ii, ch).disc_fit = runDISC(data.rois(ii, ch).time_series, disc_input);
    % display progress
    progress_msg = sprintf('Idealized %g of %g traces.\n', ii, num_traces);
    fprintf([reverse_str, progress_msg]);
    % construct string to overwrite old progress message using repeated use
    % of  the '\b' ascii character, which indicates a backspace
    reverse_str = repmat(sprintf('\b'), 1, length(progress_msg));
end
toc

save = input('Would you like to save your data? y/n [Y]: ','s');
if strcmp(save, 'N') || strcmp(save, 'n')
    return
else
    saveData();
end
