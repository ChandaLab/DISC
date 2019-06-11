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

global p 

% define default analysis parameters to be called later in dialog
p.inputParameters.input_value = 0.05;            % 95% CI
p.inputParameters.input_type = 'alpha_value';    % or 'critical_value'
p.inputParameters.divisive = 'BIC-GMM';          % lots of options 
p.inputParameters.agglomerative = 'BIC-GMM';     % lots of options
p.inputParameters.viterbi = 1;                   % 1-2 recommended
p.inputParameters.return_k = 0;                  % any nonnegative integer, unused by default in DISC
