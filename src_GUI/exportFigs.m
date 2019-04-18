function exportFigs
global p
if exist('f','var')
    clf(f);
end
checked = channelSelectDialog;
ax = gobjects(length(checked),3);
figure('units','normalized','outerposition',[0 0 1 1]);
    for jj=1:length(checked)
        ax(jj,1) = subplot(length(checked),4,(4*(jj-1)+[1,2]));
        ax(jj,2) = subplot(length(checked),4,(4*(jj-1)+3));
        ax(jj,3) = subplot(length(checked),4,(4*(jj-1)+4));
    end
    for ii = checked
        p.currentChannelIdx = ii;
        row = find(checked==ii);
        plotTrajectory(ax(row,1));
        plotHistogram(ax(row,2), ax(row,1));
        plotMetric(ax(row,3));
    end

end

function checked = channelSelectDialog
global data
dspyinfo = get(0,'screensize');
dwidth = 350;
dheight = 100 + 20*length(data.names);
d = dialog('Position',[0.5*(dspyinfo(3)-dwidth) 0.5*(dspyinfo(4)-dheight) dwidth dheight],...
           'Name','Channels to export to figure at current ROI ...');
channelCheck = gobjects(length(data.names),1);
for ii=1:length(data.names)
    channelCheck(ii) = uicontrol(d,'style','checkbox','string',data.names(ii),'Position',[0.5*dwidth-115 dheight-(ii+1)*20 300 20]);
end
btn_cancel = uicontrol(d,'string','Cancel','Position',...
                       [0.5*dwidth-115 25 100 30],'callback','delete(gcf)');
btn_export = uicontrol(d,'string','Export','Position',...
                       [0.5*dwidth+15 25 100 30],'callback',@exportChannelSelect_callback);
uiwait(d);
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