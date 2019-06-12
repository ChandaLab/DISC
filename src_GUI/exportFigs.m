function exportFigs
global p
% store channel idx so proper value is returned after for loop below
channel = p.channelIdx;
% close the figure if it is already open
if exist('f','var')
    clf(f);
end
checked = channelSelectDialog;
% allocate
ax = gobjects(length(checked),3);
figure('units','normalized','outerposition',[0 0 1 1]); % fullscreen
% make the subplots
for jj=1:length(checked)
    ax(jj,1) = subplot(length(checked),4,(4*(jj-1)+[1,2]));
    ax(jj,2) = subplot(length(checked),4,(4*(jj-1)+3));
    ax(jj,3) = subplot(length(checked),4,(4*(jj-1)+4));
end
% fill the subplots based on indices determined in dialog
for ii = checked
    p.channelIdx = ii;
    row = find(checked==ii);
    plotTrajectory(ax(row,1));
    plotHistogram(ax(row,2), ax(row,1));
    plotMetric(ax(row,3));
end
p.channelIdx = channel; % restore original channel idx
    
end

% dialog to select which channels to place in figure
function checked = channelSelectDialog
global data
% create dialog
dspyinfo = get(0,'screensize');
dwidth = 350;
dheight = 100 + 20*length(data.names);
d = dialog('Position',[0.5*(dspyinfo(3)-dwidth) 0.5*(dspyinfo(4)-dheight) dwidth dheight],...
           'Name','Channels to export to figure at current ROI ...');
% dialog adjusts to number of channels in data set
channelCheck = gobjects(length(data.names),1);
for ii=1:length(data.names)
    channelCheck(ii) = uicontrol(d,'style','checkbox','string',data.names(ii),'Position',[0.5*dwidth-115 dheight-(ii+1)*20 300 20]);
end
btn_cancel = uicontrol(d,'string','Cancel','Position',...
                       [0.5*dwidth-115 25 100 30],'callback','delete(gcf)');
btn_export = uicontrol(d,'string','Export','Position',...
                       [0.5*dwidth+15 25 100 30],'callback',@exportChannelSelect_callback);
uiwait(d);
    % export selected channels to original function; check for null
    % selection
    function exportChannelSelect_callback(~,~)
        vals = get(channelCheck,'Value');
        checked = find([vals{:}]);
        if isempty(checked)
            msgbox('Please select at least one channel to export.','Error','error');
            return
        end
        delete(gcf);
    end
end