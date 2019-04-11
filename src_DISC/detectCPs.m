function [change_point_sequence, n_change_points,first_change_point] = detectCPs(data,input_type,input_value, min_data_points);
%% Change Point Detection using Binary Segmentation and Student's T-test
% Author: David S. White
% Contact: dwhite7@wisc.edu
%
% Updates:
% ---------
% 2019-02-20    Version 1.0 Launched. DSW
%
% -------------------------------------------------------------------------
% Overview:
% ---------
% Determine 'mean-shift' transitions in the provided data using a Binary
% Segmentation approach and a two-way Student's t-test for testing
% signficance.
%           T = (|X1 - X2|) / sigma * (1/N1 + 1/N2)^0.5
%   where:
%       T = t-test statistic to compare against a critical value
%       X1 = mean of group 1
%       X2 = mean of group 2
%       sigma = standard deviation of the guassian noise in the data
%           (assumed uniform and normal)
%       N1 = number of data points in group one
%       N2 = number of data points in group two
%
%   if T > critical_value, a change-point is accepted at that position
%
% Notes:
% ------
% Adapted from MATLAB code obtained by DSW from the Goldsmith Group
% (UW-Madison). The original author of that code is Yan Jiang 09/09/07,
% and described in ref 1. The adaptation of the t-Test for significance
% testing is adapted from ref 2. 
% note: While ref 2 provides very simple code in a recursive scheme, MATLAB
% runs faster with loops vs recursion and is therefore not used here. 

% Input Variables:
% ----------------
% data = [N,1]; raw data to be analyzed. N >= 5
%
% input_type = either "critical_value" or "alpha_value" are accepted. 
%   Governs what "input_value" is. 
%   * Default is alpha_value.
%
% input_value = either a critical value or alphaValue to determine if mean
%   shifts are signifcant. 
%   Default it 1,96, ['critical_value'; 95% confidence interval]; 
%
% min_data_points = minmal segment length to check by t-test. 
%   * Default == 2.
%
% Output Variables:
% -----------------
% change_point_sequence = Intensity Levels between changepoints, [Nx1]
%
% n_change_points = number of change points found
%
% first_change_point = location of the first change-point discovered
%
% -------------------------------------------------------------------------
% References:
% -----------
% 1. Watkins & Yang, J. Phys. Chem. B, 2005, DOI: 10.1021/jp0467548
% 2. Shuang et al., J. Phys Chem Letters, 2014, DOI: 10.1021/jz501435p
% -------------------------------------------------------------------------

% Start detectCPs:
% ----------------
% Check Arguments, set defult values or print error
% Data provided
if ~exist('data','var') | isempty(data);
    disp('Error in changePoint: No data provided');
    return;
end

% Input Type
if ~exist('input_type','var') || isempty(input_type);
    input_type = 'critical_value';
end

% Input Value
if ~exist('input_value','var') || isempty(input_value);
    input_value = 1.96; % 95 % confidence interval (alpha_value = 0.05)
end

if ~exist('min_data_points','var') || isempty(min_data_points);
    min_data_points = 2; 
end

% number of data points 
n_data_points = numel(data); 

% Convert alpha_value to critical_value
% our use of a t-test is a "two-way" but 'tinv' returns one-way
% critical values. alphaValue/2 converts to two-way critical value
if strcmp(input_type, 'alpha_value')
    critical_value = tinv(1-input_value/2,n_data_points);
else
    critical_value = input_value; % was already a critical values
end

% estimate Gaussian noise by low pass Haar wavelet transform. 
% see ref 2 for details.
sorted_wavelet = sort(abs(diff(data) / 1.4));
sigma_noise = sorted_wavelet(round(0.682 * (n_data_points-1)));

% Initialize Boolean Sequence of Change Points (CP) locations.
is_change_point = zeros(1,n_data_points); % space allocation
is_change_point(1) = 1;            % first data point is a change-point
is_change_point(n_data_points) = 1;       % last data point is a change-point

first_change_point = 0; 
% Find the change points using Binary Segmentation 
% creat first segment (start to end of data)
current_change_point = 1; 
next_change_point = n_data_points;
while current_change_point < n_data_points % when not every change points are found
    % check length of the data segment
    if (next_change_point-current_change_point) >= min_data_points 
        
        % data segment for this iteration 
        data_idx = data(current_change_point+1:next_change_point);
        
        % Determine significance with a T-Test. Function nested below. 
        [T CP] = tTestCP(data_idx,sigma_noise); 
        
        if T > critical_value
            % Accept the change-point 
            is_change_point(current_change_point+CP) = 1;
            next_change_point = current_change_point+CP;
            
            % store the first change-point
            if first_change_point == 0
                first_change_point = CP;
            end
            
        else
            % Change-point not accepted, advance to next segment
            current_change_point = next_change_point;
            if current_change_point < n_data_points
                next_change_point = next_change_point+1;
                while is_change_point(next_change_point) == 0
                    next_change_point = next_change_point+1;
                end
            end
        end
    else % segment is too short, advance to the next segment of data.
        current_change_point = next_change_point;
        if current_change_point < n_data_points
            next_change_point = next_change_point+1;
            while is_change_point(next_change_point) == 0
                next_change_point = next_change_point+1;
            end
        end
    end
end

% Create change_point_sequence for output 
change_point_sequence = zeros(n_data_points,1);
start = 1;     % Start at segment at data_point 1; 
stop = 2;      % Stop at segment at data_point 2; 
n_change_points = sum(is_change_point)-2; % subtract 1 and end values
while stop <= n_data_points
    
    % Find Change-point location (Boolean)
    while is_change_point(stop) == 0
        % not a change-point, iterate
        stop = stop + 1;
    end
    
    % Change-point location found. Compute mean of data(start:stop) 
    change_point_sequence(start:stop) = mean(data(start:stop));
    
    % iterate to find next segment
    start = stop + 1;
    stop = stop + 1;
end
end

%% Run T-Tests on the segment to determine most likely break point
function [T CP] = tTestCP(data_segment,sigma_noise)
% See "Overview" above for more information on the T-Test 
%
% Input Variables:
% ----------------
% data_segment = portion of data to determine a change-point in 
%
% sigma_noise = estimated standard deviation of gaussian noise in the data
%   (not data_segment) to assume uniform. This speeds up computations by not
%   having to constantly compute a new variance, although the accuracy may
%   be slightly reduced. 
%
% Output Variables:
% ----------------
% CP = Location of change-point with the maximum T value 
%
% T = best T value computed for each of the potenital change-points in
%   data_segment
%
% -------------------------------------------------------------------------

% Start tTestCP:
% --------------
% intialize  variables 
n_data_points = numel(data_segment);
T = 0;  % T will be replaced by new maximum value
CP = 0; % CP will be replaced as T is changed 

% Speed up T-Test computations by computing all sums only once 
cum_sum = cumsum(data_segment);       
total_sum = cum_sum(end);

% main loop 
% Drop first and last data points from the loop 
% (can't compute a mean with only 1 data point)
for n = 2:n_data_points-1
    
    % compute mean of segment 1 assuming CP at k; mean(data_segment(1:CP))
    mu1 = cum_sum(n) / n;
    
    % compute mean of segment 2 assuming CP at k; mean(data_segment(1+CP:end))
    mu2 = (total_sum - cum_sum(n))/ (n_data_points-n);
    
    % compute t-value 
    t = abs((mu2 - mu1)) / sigma_noise / sqrt(1/n+1/(n_data_points-n));
    
    % is the new t value better than the current best T value? 
    if t > T
        T = t;      % best T value so far
        CP = n;     % Location of best T value 
    end
end
end