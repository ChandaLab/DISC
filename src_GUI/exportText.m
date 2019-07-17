function exportText(data, ch_idx)
% exports DISC ideal or class data to .dat file in the vein of vbFRET/HaMMy, 
% keeping four decimal places of precision.

% open dialog, cancel fcn if dialog cancels
[file, path] = uiputfile({'*.dat','Data files (*.dat)'},...
    'Export data to plain text (.dat)');
if ~file
    return
end

% concatenate
fp = [path file];

opt = typedialog;
% cancel operation unless export is explicitly pressed
if ~opt.export_pr
    disp('Export cancelled.');
    return
end

switch opt.data_sel
    case 'All analyzed traces'
        % find indices of analyzed traces
        idx = zeros(length(vertcat(data.rois(:,ch_idx).disc_fit)),1);
        for ii = 1:size(data.rois, 1)
            if ~isempty(data.rois(ii,ch_idx).disc_fit)
                idx(ii) = ii;
            end
        end
        idx = nonzeros(idx);
    case 'Selected traces only'
        % find indices of selected traces
        idx = find(vertcat(data.rois(:,1).status) == 1);
end

% construct matrix of ideal or class data (on current channel)
switch opt.data_type
    case 'Ideal'
        % allocate
        temp = zeros(size(data.rois(1,1).disc_fit.ideal,1), size(idx,1));
        for ii = idx'
            % align column index of matrix to relative index of
            % selection
            temp(:,idx==ii) = data.rois(ii,ch_idx).disc_fit.ideal;
        end
    case 'Class'
        temp = zeros(size(data.rois(1,1).disc_fit.class,1), size(idx,1));
        for ii = idx'
            temp(:,idx==ii) = data.rois(ii,ch_idx).disc_fit.class;
        end
end
% replace whitespaces with an underscore, as importdata cannot
% discern strings with whitespace as column headers
name = regexprep(char(data.names(ch_idx)), '\s', '_');
% create cell of channel name;  repeat in a row
names = cell(1, size(idx,1));  names(:) = {name};
% find largest string between channel name or largest number, and
% use this for padding.
padding = num2str(max(length(num2str(max(temp(:)))), length(name)));
fid = fopen(fp, 'wt'); % open file
% use repmat to construct arbitrarily long format spec; pad data
% with spaces to match printed channel name (or vice versa)
fprintf(fid, [repmat(['%',padding,'s\t'], 1, size(temp,2)-1)...
    ['%',padding,'s\n']], names{:});
fprintf(fid, [repmat(['%',padding,'.4f\t'], 1, size(temp,2)-1)...
    ['%',padding,'.4f\n']], temp');
fclose(fid); % close file

clear temp
disp('Data Exported.');

end

function opt = typedialog
dspyinfo = get(0,'screensize');
dwidth = 270;
dheight = 150;
d = dialog('Position',[0.5*(dspyinfo(3)-dwidth) 0.5*(dspyinfo(4)-dheight) dwidth dheight],...
    'Name','Export to .dat ...');
opt.data_type = 'Ideal'; opt.data_sel = 'All analyzed traces';
opt.export_pr = 0; % defaults

% init groups and child radios
bg1 = uibuttongroup(d,'Visible','off','Position',[0 0.3 0.3 0.7],...
    'SelectionChangedFcn',@opt1selection);
uicontrol(bg1,'Style','radiobutton','String','Ideal',...
    'Position',[10 50 100 30],'HandleVisibility','off');
uicontrol(bg1,'Style','radiobutton','String','Class',...
    'Position',[10 20 100 30],'HandleVisibility','off');
bg1.Visible = 'on'; % make group visible after children are created

bg2 = uibuttongroup(d,'Visible','off','Position',[0.3 0.3 0.7 0.7],...
    'SelectionChangedFcn',@opt2selection);
uicontrol(bg2,'Style','radiobutton','String','All analyzed traces',...
    'Position',[10 50 170 30],'HandleVisibility','off');
uicontrol(bg2,'Style','radiobutton','String','Selected traces only',...
    'Position',[10 20 170 30],'HandleVisibility','off');
bg2.Visible = 'on';

% create export button
uicontrol(d,'string','Export','Position',[75 20 100 20],...
    'callback',@goexport);

uiwait(d); % output at exit
    function opt1selection(~,event)
        opt.data_type = event.NewValue.String;
    end
    function opt2selection(~,event)
        opt.data_sel = event.NewValue.String;
    end
    function goexport(~,~)
        opt.export_pr = 1; % assure export is pressed;
        % values proceed to main fcn even if the dialog
        % is exited.
        delete(gcf);
    end

end