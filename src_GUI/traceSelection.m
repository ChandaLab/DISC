function filters = traceSelection(filters)

% Load the pop-up window for trace selection

% init, place at center of main monitor
dspyinfo = get(0,'screensize');
dwidth = 350;
dheight = 200;
d = dialog('Position',[0.5*(dspyinfo(3)-dwidth) 0.5*(dspyinfo(4)-dheight) dwidth dheight],...
    'Name','Trace Selection');

% init buttons
uicontrol(d,'string','Cancel','Position',...
    [0.5*dwidth-115 25 100 30],'callback',@traceSel_cancel_callback);
uicontrol(d,'string','Continue','Position',...
    [0.5*dwidth+15 25 100 30],'callback',@traceSel_callback);

% init checks
snr_check = uicontrol(d,'style','checkbox','string','SNR','Position',[30 150 300 20],...
    'Value',filters.enableSNR,'callback',@snr_check_callback);
numstates_check = uicontrol(d,'style','checkbox','string','# of States','Position',[30 100 300 20],...
    'Value',filters.enablenumStates,'callback',@numstates_check_callback);

% init text and edit boxes, all of which are initially invisible
txt_snr_min = uicontrol(d,'style','text','string','min','Position',[160 170, 50 20],'Visible','off');
txt_snr_max = uicontrol(d,'style','text','string','max','Position',[240 170, 50 20],'Visible','off');
edit_snr_min = uicontrol(d,'style','edit','Position',[160 150 50 20],'Visible','off',...
    'String',filters.snr_min,'callback',@edit_snr_min_callback);
edit_snr_max = uicontrol(d,'style','edit','Position',[240 150 50 20],'Visible','off',...
    'String',filters.snr_max,'callback',@edit_snr_max_callback);
txt_numstates_min = uicontrol(d,'style','text','string','min','Position',[160 120 50 20],'Visible','off');
txt_numstates_max = uicontrol(d,'style','text','string','max','Position',[240 120 50 20],'Visible','off');
edit_numstates_min = uicontrol(d,'style','edit','Position',[160 100 50 20],'Visible','off',...
    'String',filters.numstates_min,'callback',@edit_numstates_min_callback);
edit_numstates_max = uicontrol(d,'style','edit','Position',[240 100 50 20],'Visible','off',...
    'String',filters.numstates_max,'callback',@edit_numstates_max_callback);

% if certain filters were enabled on previous runs, make their params
% visible
if filters.enablenumStates
    txt_numstates_min.Visible = 'on';
    txt_numstates_max.Visible = 'on';
    edit_numstates_min.Visible = 'on';
    edit_numstates_max.Visible = 'on';
end
if filters.enableSNR
    txt_snr_min.Visible = 'on';
    txt_snr_max.Visible = 'on';
    edit_snr_min.Visible = 'on';
    edit_snr_max.Visible = 'on';
end

uiwait(d); % output when closed
    function snr_check_callback(H,~)
        % make edit boxes visible if snr is checked
        if H.Value
            txt_snr_min.Visible = 'on';
            txt_snr_max.Visible = 'on';
            edit_snr_min.Visible = 'on';
            edit_snr_max.Visible = 'on';
            filters.enableSNR = 1;
        else
            txt_snr_min.Visible = 'off';
            txt_snr_max.Visible = 'off';
            edit_snr_min.Visible = 'off';
            edit_snr_max.Visible = 'off';
            filters.enableSNR = 0;
        end
    end
    function numstates_check_callback(H,~)
        % make edit boxes visible if numstates is checked
        if H.Value
            txt_numstates_min.Visible = 'on';
            txt_numstates_max.Visible = 'on';
            edit_numstates_min.Visible = 'on';
            edit_numstates_max.Visible = 'on';
            filters.enablenumStates = 1;
        else
            txt_numstates_min.Visible = 'off';
            txt_numstates_max.Visible = 'off';
            edit_numstates_min.Visible = 'off';
            edit_numstates_max.Visible = 'off';
            filters.enablenumStates = 0;
        end
    end
% export edit strings (as doubles)
    function edit_snr_min_callback(H,~)
        filters.snr_min = str2double(get(H,'string'));
        if isnan(filters.snr_min)
            filters.snr_min = [];
        end
    end
    function edit_snr_max_callback(H,~)
        filters.snr_max = str2double(get(H,'string'));
        if isnan(filters.snr_max)
            filters.snr_max = [];
        end
    end
    function edit_numstates_min_callback(H,~)
        filters.numstates_min = str2double(get(H,'string'));
        if isnan(filters.numstates_min)
            filters.numstates_min = [];
        end
    end
    function edit_numstates_max_callback(H,~)
        filters.numstates_max = str2double(get(H,'string'));
        if isnan(filters.numstates_max)
            filters.numstates_max = [];
        end
    end
% for ease of conditions in main GUI, assure output params are empty if the
% dialog is cancelled
    function traceSel_cancel_callback(~,~)
        filters.contpr = 0;
        delete(gcf);
    end
% export checks only when 'Continue' is pressed
    function traceSel_callback(~,~)
        filters.contpr = 1; % tell struct 'continue' has been pressed
        filters.snrEnable = get(snr_check,'Value');
        filters.numstatesEnable = get(numstates_check,'Value');
        delete(gcf);
    end
end