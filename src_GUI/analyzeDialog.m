function analyzeDialog()
% Operate the Analyze & Analyze All Buttons & runDISC with provided input
%
% Authors: Owen Rafferty & David S. White
% Contact: dwhite7@wisc.edu

% Updates: 
% --------
% 18-12-02  OMR Wrote the code 
% 19-02-21  DSW Comments added.  
% 19-20-20  DSW Added in AIC_GMM and HQC_GMM as clustering options


% input variables 
global data p 

% init dialog window
d = dialog('Position',[620 400 350 260],'Name','DISC Parameters');

% create aesthetic panels
rpanel = uipanel(d,'Position',[0.5 0.4 0.4 0.55]);
llowerpanel = uipanel(d,'Position',[0.14 0.29 0.35 0.3]);

% create button group/panel for threshold type selection
bg_threshold = uibuttongroup(d,'Position',[0.14 0.6 0.35 0.38],'Title','Threshold Value','Visible','off',...
                             'SelectionChangedFcn',@thresholdSelection);

% create threshold edit box and radio from selection of threshold type                         
edit_threshold = uicontrol(bg_threshold,'Style','edit','Position',[6 50 60 20],...
                           'String',p.inputParameters.thresholdValue,...
                           'Horizontalalignment','left','Callback',@edit_threshold_callback);
radio_alpha_threshold = uicontrol(bg_threshold,'Style','radiobutton','Position',[6 26 100 20],...
                                  'String','Alpha Value','HandleVisibility','off');
radio_critical_threshold = uicontrol(bg_threshold,'Style','radiobutton','Position',[6 6 120 20],...
                                     'String','Critical Value','HandleVisibility','off');
align([edit_threshold radio_alpha_threshold radio_critical_threshold], 'distributed','left')

% check if last run altered default theshold type, and use altered value if so
switch p.inputParameters.thresholdType
    case 'alpha_value'
        set(bg_threshold,'SelectedObject',radio_alpha_threshold);
    case 'critical_value'
        set(bg_threshold,'SelectedObject',radio_critical_threshold);
end
% and make the group visible
bg_threshold.Visible = 'on';                   

% create iterations label and input
txt_iterations = uicontrol(llowerpanel,'Style','text','Position',[6 30 110 40],...
                           'String','Viterbi Iterations','HorizontalAlignment','left');
edit_iterations = uicontrol(llowerpanel,'Style','edit','Position',[6 10 60 20],...
                            'String',p.inputParameters.hmmIterations,'HorizontalAlignment','left','Callback',@edit_iterations_callback);

% create divisive IC label and popup                 
txt_divisiveIC = uicontrol(rpanel,'Style','text','Position',[10 105 100 20],...
                           'String','Divisive IC','HorizontalAlignment','left');
popup_divisiveIC = uicontrol(rpanel,'Style','popup','Position',[10 85 100 20],...
                             'String',{'AIC-GMM';'BIC-GMM';'BIC-RSS';'HQC-GMM';'MDL'},'Visible','off',...
                             'Callback',@popup_divisiveIC_callback);
                         
% check if last run altered default divIC parameters, and use altered values if so
switch p.inputParameters.divisiveIC
    case {'AIC-GMM' 'AIC_GMM'}
        set(popup_divisiveIC,'Value',1)
    case {'BIC-GMM' 'BIC_GMM'}
        set(popup_divisiveIC,'Value',2)
    case {'BIC-RSS' 'BIC_RSS'}
        set(popup_divisiveIC,'Value',3)
    case {'HQC-GMM' 'HQC_GMM'}
        set(popup_divisiveIC,'Value',4)
    case 'MDL'
        set(popup_divisiveIC,'Value',5)
end

% and make the group visible
popup_divisiveIC.Visible = 'on';

% create agglomerative IC label and popup
txt_agglomerativeIC = uicontrol(rpanel,'Style','text','Position',[10 45 120 20],...
                                'String','Agglomerative IC','HorizontalAlignment','left');
popup_agglomerativeIC = uicontrol(rpanel,'Style','popup','Position',[10 25 100 20],...
                                  'String',{'AIC-GMM';'BIC-GMM';'BIC-RSS';'HQC-GMM';'MDL';'none'},'Visible','off',...
                                  'Callback',@popup_agglomerativeIC_callback);

% check if last run altered default aggIC parameters, and use altered values if so
switch p.inputParameters.agglomerativeIC
    case {'AIC-GMM' 'AIC_GMM'}
        set(popup_agglomerativeIC,'Value',1)
    case {'BIC-GMM' 'BIC_GMM'}
        set(popup_agglomerativeIC,'Value',2)
    case {'BIC-RSS' 'BIC_RSS'}
        set(popup_agglomerativeIC,'Value',3)
    case {'HQC-GMM' 'HQC_GMM'}
        set(popup_agglomerativeIC,'Value',4)
    case 'MDL'
        set(popup_agglomerativeIC,'Value',5)
    case 'none'
        set(popup_agglomerativeIC,'Value',6)
        
end
% and make the group visible 
popup_agglomerativeIC.Visible = 'on';

% create cancel and go buttons
btn_cancel = uicontrol('Parent',d,'Position',[65 25 100 30],'String','Cancel','Callback','delete(gcf)');
btn_go = uicontrol('Parent',d,'Position',[185 25 100 30],'String','Go','Callback',@goAnalyze);

% callback functions for dialog. these functions are unused if the default
% values are unchanged
uiwait(d);
    function edit_threshold_callback(H,~) % called by a custom threshold value
        p.inputParameters.thresholdValue = str2double(get(H,'string'));
    end
    function thresholdSelection(~,event) % called by a threshold type
        switch event.NewValue.String
            case 'Alpha Value'
                p.inputParameters.thresholdType = 'alpha_value';
            case 'Critical Value'
                p.inputParameters.thresholdType = 'critical_value';
        end
    end

    function edit_iterations_callback(H,~) % called by a custom number of iterations
        p.inputParameters.hmmIterations = str2double(get(H,'string'));
    end

    function popup_divisiveIC_callback(popup,~) % called by a change in divIC type
        idx = popup.Value;
        popup_items = popup.String;
        p.inputParameters.divisiveIC = char(popup_items(idx,:));
    end

    function popup_agglomerativeIC_callback(popup,~) % called by a change in aggIC type
        idx = popup.Value;
        popup_items = popup.String;
        p.inputParameters.agglomerativeIC = char(popup_items(idx,:));
    end
    function goAnalyze(~,~) % called by "Go" button to gather parameters to send to runDISC and check for their validity.  
        if mod(p.inputParameters.hmmIterations,1) ~= 0 || p.inputParameters.hmmIterations < 0
            msgbox('Number of iterations must be an integer greater than or equal to 0','Error','error');
            return;
        end
       
        % Error Check for alpha values not between 0 and 1
        if strcmp(p.inputParameters.thresholdType, 'alpha_value')
            if p.inputParameters.thresholdValue > 1 || p.inputParameters.thresholdValue < 0
                msgbox('Alpha Value must be between 0 and 1', 'Error','error');
                return;
            end
        end
        
        % Error check for negative critical values 
        if strcmp(p.inputParameters.thresholdType, 'critical_value')
            if p.inputParameters.thresholdValue < 0 
                msgbox('Critical Value must be between greater than 0', 'Error','error');
                return;
            end
        end
        delete(gcf)
        
        
        % run DISC at current ROI and channel
        if p.analyzeAll == 0
        [data.rois(p.roiIdx, p.currentChannelIdx).Components, ...
         data.rois(p.roiIdx, p.currentChannelIdx).Ideal, ...
         data.rois(p.roiIdx, p.currentChannelIdx).Class, ...
         data.rois(p.roiIdx, p.currentChannelIdx).Metric,...
         data.rois(p.roiIdx, p.currentChannelIdx).DISC_FIT] =  ...
        runDISC(data.rois(p.roiIdx, p.currentChannelIdx).zproj, ... % run DISC
                p.inputParameters.thresholdType, ... 
                p.inputParameters.thresholdValue, ... 
                p.inputParameters.divisiveIC, ...
                p.inputParameters.agglomerativeIC, ...
                p.inputParameters.hmmIterations);
        goToROI(p.roiIdx);
        
        % run DISC on all ROIs for current channel
        elseif p.analyzeAll == 1
            waitName = sprintf("Running DISC on channel '%s' ...",...
                               char(data.names(p.currentChannelIdx))); % waitbar title
            f = waitbar(0,'1','Name',waitName,...
                        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)'); % init waitbar
            setappdata(f,'canceling',0);
            for i = 1:size(data.rois,1)
                if getappdata(f,'canceling') % stop analysis if cancel is clicked
                    break
                end
                waitbar(i/size(data.rois,1),f,sprintf(['ROI ',num2str(i),' of ',num2str(size(data.rois,1))])) % call waitbar and display progress
                [data.rois(i, p.currentChannelIdx).Components, ...
                 data.rois(i, p.currentChannelIdx).Ideal, ...
                 data.rois(i, p.currentChannelIdx).Class, ...
                 data.rois(i, p.currentChannelIdx).Metric, ...
                 data.rois(i, p.currentChannelIdx).DISC_FIT] = ...
                runDISC(data.rois(i, p.currentChannelIdx).zproj, ... % run DISC
                        p.inputParameters.thresholdType, ... 
                        p.inputParameters.thresholdValue, ... 
                        p.inputParameters.divisiveIC, ...
                        p.inputParameters.agglomerativeIC, ...
                        p.inputParameters.hmmIterations);
            end
            goToROI(p.roiIdx); % display ROI selected before analysis
            delete(f); % close waitbar
        end     
        
    end
end