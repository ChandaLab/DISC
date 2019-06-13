function initDISC()
% Set default values for DISC analysis in the GUI
% need to update with setDefault.m
%
% Authors: David S. White 
% Contact: dwhite7@wisc.edu 
%
% updated: 
% 2019-04-09    DSW Wrote the code
%
% Feel free to update these values for your own convenience!!

global gui

% define default analysis parameters to be called later in dialog
gui.disc_parameters.input_value = 0.05;            % 95% CI
gui.disc_parameters.input_type = 'alpha_value';    % or 'critical_value'
gui.disc_parameters.divisive = 'BIC-GMM';          % lots of options
gui.disc_parameters.agglomerative = 'BIC-GMM';     % lots of options
gui.disc_parameters.viterbi = 1;                   % 1-2 recommended
gui.disc_parameters.return_k = 0;                  % any positive integer,
                                                   % unused by default in DISC
