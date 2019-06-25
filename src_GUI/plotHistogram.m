function plotHistogram(axes, alignaxes, channel_colors, font)
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
global data gui

% clear out anything in the previous plot 
cla(axes); 

% grab plot color
bin_color = channel_colors(gui.channelIdx,:);

% grab data to plot 
time_series = data.rois(gui.roiIdx, gui.channelIdx).time_series;

% init histogram stuff
bins = 100; 
max_value = round(max(time_series),1);
min_value = round(min(time_series),-1);
if isempty(max_value) || isempty(min_value)
    return;
end
edges = linspace(min_value, max_value, bins);
data_counts = histcounts(time_series, edges);
data_range = edges(1:end-1);

% Does data.rois.components (i.e. "data fit") exist?
if isempty(data.rois(gui.roiIdx, gui.channelIdx).disc_fit)
    
    % Lets just plot out the data by itself and exit
    bar(axes,data_range,data_counts,'FaceColor',bin_color,'EdgeColor',bin_color,'BarWidth',1);
    hold(axes,'on');
    set(axes,'xtick',[]); set(axes,'ytick',[]); view(axes,[90,-90])
    
    % set the axis to match the time series plot (alignaxes) axis.
    xlim(axes, get(alignaxes,'Ylim'))
    return;
end

% If data.rois.components exists, we can plot the histogram fits

% plot raw data histogram
bar(axes,data_range,data_counts,'FaceColor',bin_color,'EdgeColor',bin_color,'BarWidth',1); 
hold(axes,'on');

% grab components
components = data.rois(gui.roiIdx, gui.channelIdx).disc_fit.components; 
n_components = size(components,1); 

% Evalute and plot each component individually
gauss_fit_all = zeros(size(data_range)); 
for n = 1:n_components
    w = components(n,1);       % weight
    mu = components(n,2);      % mu
    sigma = components(n,3);   % sigma
    
    % Evaluate each gaussian distribtution
    norm_dist_pdf = normpdf(data_range, mu, sigma).*trapz(data_range, data_counts);
    
    % store sum for gauss_fit_all
    gauss_fit_all = gauss_fit_all + w .* normpdf(data_range, mu, sigma);
    
    % convert PDF to distribution
    norm_dist = norm_dist_pdf * round(w,2);
    
    % plot this gaussian component onto the histogram 
    plot(axes, data_range, norm_dist,  '--k', 'linewidth', 1.5);

end

% Compute the sum of all Gaussians
gauss_fit_all = gauss_fit_all.* trapz(data_range, data_counts);
plot(axes, data_range, gauss_fit_all, '-k', 'linewidth', 1.7);

hold(axes,'off'); set(axes,'xtick',[]); set(axes,'ytick',[]); view(axes,[90,-90])
xlim(axes, get(alignaxes,'Ylim'))

% draw number of states and SNR (if it exists) in the title
snr = data.rois(gui.roiIdx, gui.channelIdx).SNR;
if isempty(snr)
    title_txt = sprintf('Number of States: %u', n_components);
else
    title_txt = sprintf('SNR: %.1f   Number of States: %u', snr, n_components);
end
title(axes, title_txt, 'HorizontalAlignment','left');
set(axes, 'fontsize', font.size);
set(axes, 'fontname', font.name);

end