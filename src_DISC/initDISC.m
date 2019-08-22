function disc_input = initDISC(disc_input)
% David S. White
% dwhite7@wisc.edu
%
% Updates: 
% --------
% 2019-04-10    DSW     v1.1.0 DSW wrote the code 
%
% Overview: 
% ---------
% Set default values for arguments in runDISC. 
% User modification is encouraged! 

% ******************* User modification HERE! *****************************
% init default structure
if ~exist('disc_input','var')
  disc_input = struct; 
end
default = struct; 
%
% Change-Point Detection:
% -----------------------
default.input_type = 'alpha_value'; % Can be "alpha_value" or "critical_value" 
default.input_value = 0.05; % either alpha value (1 - confidence interaval) or critical value 
%
% Objective Functions/ Information Criteria:
% --------------------------------------------
default.divisive = 'BIC_GMM'; 
default.agglomerative = 'BIC_GMM'; 
% See computeIC for a list of all code options 
%
% Viterbi Iterations:
% -------------------
default.viterbi = 1; % recommended either 1 or 2. 0 skips viterbi
%
% Number of States to Return: 
% --------------------------
default.return_k = 0; 
% if empty, skip. Else, return  the provided number or the highest obtained 
%
% ********************* End User modification *****************************
%
% Run check on all fields. Should not need to modify this section. 

% Input Type
if ~isfield(disc_input,'input_type')|| isempty(disc_input.input_type)
    disc_input.input_type = default.input_type; 
end

% Input Value
if ~isfield(disc_input,'input_value') || isempty(disc_input.input_value)
    disc_input.input_value = default.input_value; % 95 % confidence interval
end

% Divisive Information Criterion
if ~isfield(disc_input, 'divisive') || isempty(disc_input.divisive)
    disc_input.divisive = default.divisive;
end

% Agglomerative Information Criterion
if ~isfield(disc_input, 'agglomerative') || isempty(disc_input.agglomerative)
   disc_input.agglomerative = default.agglomerative; 
end

% Viterbi Iterations
if ~isfield(disc_input, 'viterbi')
    disc_input.viterbi = 1; % typically find diminishing returns beyond 2
elseif isempty(disc_input.viterbi)
    disc_input.viterbi = 0; % easier than checking for empty    
end

% Number of States to return
if ~isfield(disc_input,'return_k') || isempty(disc_input.return_k)
    disc_input.return_k = default.return_k;  % Do not use.
end
