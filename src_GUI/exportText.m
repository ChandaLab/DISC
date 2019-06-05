function exportText()
% exports DISC fit data to .dat file in the vein of vbFRET/HaMMy
global p data

% open dialog, cancel fcn if dialog cancels
[file, path] = uiputfile({'*.dat','Data files (*.dat)'},...
    'Export data to plain text (.dat)');
if isequal(file, 0)
    return;
end

% store path and ext
p.fp = fullfile(path, file);
[~, ~, ext] = fileparts(p.fp);

opt = typedialog;
% cancel operation unless export is explicitly pressed
if opt.export_pr ~= 1
    disp('Export cancelled.');
    return
end

switch opt.data_sel
    case 'All analyzed traces'
        % find indices of analyzed traces
        idx = zeros(length(vertcat(data.rois(:,p.currentChannelIdx).disc_fit)),1);
        for ii = 1:size(data.rois, 1)
            if ~isempty(data.rois(ii,p.currentChannelIdx).disc_fit)
                idx(ii) = ii;
            end
        end
        idx = nonzeros(idx);
    case 'Selected traces only'
        % find indices of selected traces
        idx = find(vertcat(data.rois(:,1).status) == 1);
end

switch lower(ext) % will probably add support for other plain text formats in the future
    case '.dat'
        % construct matrix of ideal or class data (on current channel)
        switch opt.data_type
            case 'Ideal'
                % allocate
                temp = zeros(size(data.rois(1,1).disc_fit.ideal,1),...
                    size(idx,1));
                for ii = idx'
                    % align column index of matrix to relative index of
                    % selection
                    temp(:,find(idx==ii)) = ... 
                        data.rois(ii,p.currentChannelIdx).disc_fit.ideal;
                end
            case 'Class'
                temp = zeros(size(data.rois(1,1).disc_fit.class,1),...
                    size(idx,1));
                for ii = idx'
                    temp(:,find(idx==ii)) = ...
                        data.rois(ii,p.currentChannelIdx).disc_fit.class;
                end
        end
        % create file, write headers, close file
        fid = fopen(p.fp, 'wt');
        % replace spaces (and some other characters) with an underscore, as
        % importdata cannot discern strings with spaces as column headers
        name = regexprep(data.names(p.currentChannelIdx), '\s', '_');
        for ii = 1:(size(idx, 1) - 1)
            fprintf(fid, '%s\t', char(name));
        end
        fprintf(fid, '%s\n', char(name)); % last header w/ newline instead of tab
        fclose(fid);
        % append data under headers. there are probably more efficient
        % methods of doing this than dlmwrite.
        dlmwrite(p.fp, temp, '-append', 'delimiter', '\t');
end

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
        opt.export_pr = 1; % assure export is pressed; values proceed to
        % values proceed to main fcn even if the dialog
        % is exited.
        delete(gcf);
    end

end