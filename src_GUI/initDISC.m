function initDISC()
% Set default values for DISC analysis
%
% Authors: David S. White 
% Contact: dwhite7@wisc.edu 
%
% updated: 
% 2019-04-09    DSW Wrote the code
%
% Feel free to update these values for your own convenience!!

global data p 

% define default analysis parameåters to be called later in dialog
p.inputParameters.thresholdValue = 0.05;            % 95% CI
p.inputParameters.thresholdType = 'alpha_value';    % or 'critical_value'
p.inputParameters.divisiveIC = 'BIC-GMM';           % lots of options 
p.inputParameters.agglomerativeIC = 'BIC-GMM';      % lots of options
p.inputParameters.hmmIterations = 1;                % 1-2 recommended 
