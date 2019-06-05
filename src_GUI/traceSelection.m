function params = traceSelection()
% init, place at center of main monitor
dspyinfo = get(0,'screensize');
dwidth = 350;
dheight = 200;
d = dialog('Position',[0.5*(dspyinfo(3)-dwidth) 0.5*(dspyinfo(4)-dheight) dwidth dheight],...
    'Name','Trace Selection');

% init buttons
btn_cancel = uicontrol(d,'string','Cancel','Position',...
    [0.5*dwidth-115 25 100 30],'callback',@traceSel_cancel_callback);
btn_continue = uicontrol(d,'string','Continue','Position',...
    [0.5*dwidth+15 25 100 30],'callback',@traceSel_callback);

% init checks
snr_check = uicontrol(d,'style','checkbox','string','SNR','Position',[30 150 300 20],...
    'callback',@snr_check_callback);
numstates_check = uicontrol(d,'style','checkbox','string','# of States','Position',[30 100 300 20],...
    'callback',@numstates_check_callback);

% init text and edit boxes, all of which are initially invisible
txt_snr_min = uicontrol(d,'style','text','string','min','Position',[160 170, 50 20],'Visible','off');
txt_snr_max = uicontrol(d,'style','text','string','max','Position',[240 170, 50 20],'Visible','off');
edit_snr_min = uicontrol(d,'style','edit','Position',[160 150 50 20],'Visible','off',...
    'callback',@edit_snr_min_callback);
edit_snr_max = uicontrol(d,'style','edit','Position',[240 150 50 20],'Visible','off',...
    'callback',@edit_snr_max_callback);
txt_numstates_min = uicontrol(d,'style','text','string','min','Position',[160 120 50 20],'Visible','off');
txt_numstates_max = uicontrol(d,'style','text','string','max','Position',[240 120 50 20],'Visible','off');
edit_numstates_min = uicontrol(d,'style','edit','Position',[160 100 50 20],'Visible','off',...
    'callback',@edit_numstates_min_callback);
edit_numstates_max = uicontrol(d,'style','edit','Position',[240 100 50 20],'Visible','off',...
    'callback',@edit_numstates_max_callback);

uiwait(d); % output when closed
    function snr_check_callback(H,~)
        % make edit boxes visible if snr is checked
        if H.Value == 1
            txt_snr_min.Visible = 'on';
            txt_snr_max.Visible = 'on';
            edit_snr_min.Visible = 'on';
            edit_snr_max.Visible = 'on';
        else
            txt_snr_min.Visible = 'off';
            txt_snr_max.Visible = 'off';
            edit_snr_min.Visible = 'off';
            edit_snr_max.Visible = 'off';
        end
    end
    function numstates_check_callback(H,~)
        % make edit boxes visible if numstates is checked
        if H.Value == 1
            txt_numstates_min.Visible = 'on';
            txt_numstates_max.Visible = 'on';
            edit_numstates_min.Visible = 'on';
            edit_numstates_max.Visible = 'on';
        else
            txt_numstates_min.Visible = 'off';
            txt_numstates_max.Visible = 'off';
            edit_numstates_min.Visible = 'off';
            edit_numstates_max.Visible = 'off';
        end
    end
% export edit strings (as doubles)
    function edit_snr_min_callback(H,~)
        params.snr_min = str2double(get(H,'string'));
    end
    function edit_snr_max_callback(H,~)
        params.snr_max = str2double(get(H,'string'));
    end
    function edit_numstates_min_callback(H,~)
        params.numstates_min = str2double(get(H,'string'));
    end
    function edit_numstates_max_callback(H,~)
        params.numstates_max = str2double(get(H,'string'));
    end
% for ease of conditions in main GUI, assure output params are empty if the
% dialog is cancelled
    function traceSel_cancel_callback(~,~)
        params = [];
        delete(gcf);
    end
% export checks only when 'Continue' is pressed
    function traceSel_callback(~,~)
        params.contpr = 1; % tell struct continue has been pressed
        params.snrEnable = get(snr_check,'Value');
        params.numstatesEnable = get(numstates_check,'Value');
        delete(gcf);
    end
end