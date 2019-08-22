Q = [0,0.2;0.2,0];
durations_s = 1e2
n_per_dur = 1;
time_series = cell(n_per_dur,length(durations_s));
n_events = zeros(n_per_dur,length(durations_s));

for d = 1:length(durations_s)
    for n = 1:n_per_dur
        ss = simulateQ(Q, [1,2], durations_s(d), 10); 
        time_series{n,d}= normrnd(ss,0.2);
    end
end
figure; plot(time_series{1,1})

%% 
 [c,cc] = kmeansElkan(time_series{1,1},2);
 [~,ideal] = computeCenters(time_series{1,1},cc);
figure; plot(time_series{1,1}); hold on; scatter(1:length(ideal),ideal) ;

disc_fit = runDISC(time_series{1,1}); 
plot(disc_fit.ideal,'-k'); 

hold on; 
 [~,real] = computeCenters(time_series{1,1},ss);
 plot(real,':r')

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