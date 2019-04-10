function plotHistogram()
% Histogram fitting figure for time series data
%
% Author: David S. White & Owen Rafferty
% Contact: dwhite7@wisc.edu
%
% Updates: 
% --------
% 2018-07-11    DSW     Wrote code (HistFitFig.m)
% 2019-02-21    DSW     Full rewrite. Addded comments. Changed name to
%                       plotHistogram.m
% 2019-04-10    DSW     updated to new disc_fit structure

% input variables
global p data

% clear out anything in the previous plot 
cla(p.h2); 

% grab plot color
bin_color = p.channelColors(data.names{p.currentChannelIdx});

% grab data to plot 
time_series = data.rois(p.roiIdx, p.currentChannelIdx).time_series;

% init histogram stuff
bins = 100; 
max_value = round(max(time_series),1);
min_value = round(min(time_series),-1);
bins = linspace(min_value, max_value, bins);
counts = hist(time_series, bins);
data_range = bins(1:end-1);
data_counts = counts(1:end-1);

% Does data.rois.Components (i.e. "data fit") exist?
if isempty(data.rois(p.roiIdx,p.currentChannelIdx).disc_fit)
    
    % Lets just plot out the data by itself and exit
    bar(p.h2,data_range,data_counts,'FaceColor',bin_color,'BarWidth',1,'EdgeAlpha',0); hold(p.h2,'on');
    set(p.h2,'xtick',[]); set(p.h2,'ytick',[]); view(p.h2,[90,-90])
    
    % set the axis to match the time series plot (p.h1) axis.
    xlim(p.h2, get(p.h1,'Ylim'))
    return;
end

% If data.rois.Components exists, we can plot the histogram fits

% plot raw data histogram
bar(p.h2,data_range,data_counts,'FaceColor',bin_color,'BarWidth',1,'EdgeAlpha',0); hold(p.h2,'on');

% grab components
components = data.rois(p.roiIdx, p.currentChannelIdx).disc_fit.components; 
n_components = size(components,1); 

% Evalute and plot each component individually
gauss_fit_all = zeros(size(data_range)); 
for n = 1:n_components
    w = components(n,1);       % weight
    mu = components(n,2);      % mu
    sigma = components(n,3);   % sigma
    
    % Evaluate each gaussian distribtution
    norm_dist_pdf = normpdf(data_range, mu,sigma).*trapz(data_range,data_counts);
    
    % store sum for gauss_fit_all
    gauss_fit_all = gauss_fit_all + w .* normpdf(data_range, mu, sigma);
    
    % convert PDF to distribution
    norm_dist = norm_dist_pdf * round(w,2);
    
    % plot this gaussian component onto the histrogram 
    plot(p.h2, data_range, norm_dist,  '--k', 'linewidth', 1.5);

end

% Compute the sum of all Gaussians
gauss_fit_all = gauss_fit_all.* trapz(data_range,data_counts);
plot(p.h2, data_range, gauss_fit_all, '-k', 'linewidth', 1.7);

hold(p.h2,'off'); set(p.h2,'xtick',[]); set(p.h2,'ytick',[]); view(p.h2,[90,-90])
xlim(p.h2, get(p.h1,'Ylim'))

% plot number of state as the title
title(p.h2, ['Number of States: ', num2str(n_components)]);
set(p.h2, 'fontsize', p.fontSize);
set(p.h2, 'fontname', p.fontName);

end