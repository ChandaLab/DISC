Q = [0,0.2;0.2,0];
durations_s = [1e1,1e2,1e3,1e4,1e5];
n_per_dur = 2;
time_series = cell(n_per_dur,length(durations_s));
n_events = zeros(n_per_dur,length(durations_s));

for d = 1:length(durations_s)
    d
    for n = 1:n_per_dur
        time_series{n,d}= normrnd(simulateQ(Q, [1,2], durations_s(d), 10),0.2);
    end
end
% figure; plot(time_series{10,2})

%% 
time_s = zeros(n_per_dur,length(durations_s));
for d = 1:length(durations_s)
    d
    for n = 1:n_per_dur
        tic
        disc_fit = runDISC(time_series{n,d}); 
        time_s(n,d) = toc; 
    end
end

figure; errorbar(durations_s,mean(time_s),std(time_s));
set(gca,'xscale','log')
set(gca,'yscale','log')