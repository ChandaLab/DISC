durations_s = linspace(1e0,1e3,10)
n_per_condition = 3;

accuracy= zeros(length(durations_s),2);
time_s = zeros(length(durations_s),2);

%% run the simulation
data.rois = struct;
data.fcAMP_uM = 1;
data.Q_matrix = [0,0.15,0,0;0.04,0,0.23*data.fcAMP_uM,0;0,0.95,0,0.51;0,0,0.31,0];

data.emission_states = [1,1,2,2];
data.bound_intensities = makedist('lognormal','mu', 4.63, 'sigma',0.43);

% with heterogenous fcAMP intensities
data.bound_variation = makedist('exponential','mu',3.81);

% without heterogenous fcAMP intensities
%data.bound_variation = [];

% Run the simulations
data.frame_rate_s = 0.1;
snr = [3,5,7];
n_sites = 4;

figure;
idx = 0;
for s = 1:length(snr);
    simulations = [];
    for d =1:length(durations_s) % check between 1 and 4 binding sites
        d
        t = zeros(n_per_condition,1);
        a = zeros(n_per_condition,1);
        for n = 1:n_per_condition
            sim = smSimulateBinding(durations_s(d), data.frame_rate_s, n_sites, snr(s), data.Q_matrix, ...
                data.emission_states, data.bound_intensities, data.bound_variation);
            % run DISC
            tic
            disc_fit = runDISC(sim.zproj);
            t(n) = toc;
            
            % accuracy
            a(n) = idealizationMetrics(sim.zproj, disc_fit.class,sim.state_seq, 'overall', 0.1,1);
            
            % store
            sim.disc_fit = disc_fit;
            simulations = [simulations;sim];
        end
        % store mean and std values;
        time_s(d,1)= mean(t);
        time_s(d,2)= std(t);
        accuracy(d,1)= mean(a);
        accuracy(d,2)= std(a);
    end
    % store;
    data.rois = simulations;
    
    %
    %idx = idx + 1;
    subplot(1,2,1);
    errorbar(durations_s,accuracy(:,1),accuracy(:,2),'-o'); hold on
    title('accuracy');
    pbaspect([1,1,1]);
    
    %idx = idx + 1;
    subplot(1,2,2);
    errorbar(durations_s,time_s(:,1),time_s(:,2),'-o'); hold on
    title('time_s');
    pbaspect([1,1,1]);
    
end