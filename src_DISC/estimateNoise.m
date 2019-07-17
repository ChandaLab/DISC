function sigma_noise = estimateNoise(data, option)
%% Estimate Standard Deviation of Noise in data with low pass haar wavelet
% David S. White
% dwhite7@wisc.edu
%
% Updates:
% 2019-02-20    DSW     version 1.0
%
%--------------------------------------------------------------------------
% Requirements:
% -------------
% MATLAB Wavelet Toolbox required (Option 2 only)
%
% Input Variables:
% ----------------
% data = 1D time series of data. 
%
% option = how to estimate the standard deviation of gaussian noise 
%   option 1 = Adapted from STaSI (ref 1)
%   option 2 = Adapted from OWLET_denoise (ref 2)
%
% Note: Estimates from option 2 are slightly higher than option 1, but
% option 1 is faster and does not require the Wavelet Toolbox
%
% Output Variables:
% ----------------
% sigma_noise =  estimated standard deviation of noise in data

%--------------------------------------------------------------------------
% References:
% -----------
% Option 1:
%   Shuang et al., "Fast Step Transition and State Identification (STaSI)
%   for Discrete Single-Molecule Data Analysis," The Journal of Physical
%   Chemistry Letters 2014 5 (18), 3157-3161 DOI: 10.1021/jz501435p
%
% Option 2:
% 2. Luisier F., Blu T., Unser M. "A New SURE Approach to Image
%   Denoising: Interscale Orthonormal Wavelet Thresholding,"
%   IEEE Transactions on Image Processing, vol. 16, no. 3, pp. 593-606,
%   March 2007.

%% Run
% input variables
if ~exist('data','var') || isempty(data)
    sigma_noise = []; 
    disp('Error in estimateNoise: X not provided');
    return; 
end
if ~exist('option','var') || isempty(option)
    option = 1; 
end

if option == 1
    % General Idea:
    % The standard deviation of the noise can be estimated as 1/2 ^ 0.5 of the
    % standard deviation of a low pass haar wavelet transform.
    
    % code modified from Reference 1
    sorted_wavelet = sort(abs(diff(data) / 1.4));
    sigma_noise = sorted_wavelet(round(0.682 * numel(sorted_wavelet)));
    
else
    % Adapted from Reference 2 using Robust Median Estimator
    
    % Max decomposition level
    n_data = length(data);
    level = fix(log2(n_data));
    % Haar wavelet tranform
    wave_dec = wavedec(data,level,'haar');
    % median estimator
    HH = wave_dec(round(n_data/2)+1:end,1:end);
    sigma_noise = median(abs(HH))/0.6745;
    
end

