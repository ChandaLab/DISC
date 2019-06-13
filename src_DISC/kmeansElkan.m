function [centers,mincenter,mindist,q2,quality] = kmeansElkan(data,initcenters)
% 
% This script was downloaded by David S. White and modified for our use case. 
% See: https://github.com/probml/pmtk3
%
% MIT License Copyright (2010) Kevin Murphy and Matt Dunham
%
% Kmeans clustering using Elkan's triangle inequality speedup
% output: final centers
% input: data points and initial centers
% if initcenters is a number k, create k centers and start with these
% otherwise, use centers given as input
% method = 0: unoptimized, using n by k matrix of distances O(nk) space
%          1: vectorized, using only O(n+k) space
%          2: like 1, in addition using distance inequalities (default)

%PMTKauthor Charles Elkan

% "Using the triangle inequality to accelerate k-means",
% ICML 2003

[n,dim] = size(data);

if max(size(initcenters)) == 1
    k = initcenters;
    [centers, mincenter, mindist, ~, computed] = anchors(mean(data),k,data);
    total = computed;
    skipestep = 1;
else 
    centers = initcenters;
    mincenter = zeros(n,1);
    total = 0;
    skipestep = 0;
    [k,dim2] = size(centers);    
    if dim ~= dim2 
        error('dim(data) ~= dim(centers)'); 
    end
end

nchanged = n;
iteration = 0;
oldmincenter = zeros(n,1);

while nchanged > 0
    % do one E step, then one M step
    computed = 0;
    
    if ~skipestep
        mindist = Inf*ones(n,1);
        lower = zeros(n,k);
        for j = 1:k
           jdist = calcdist(data,centers(j,:));
           lower(:,j) = jdist;
           track = find(jdist < mindist);
           mindist(track) = jdist(track);
           mincenter(track) = j;
        end
        computed = k*n;
    end % if method
        
% M step: recalculate the means for each cluster
% if a cluster is empty, its mean is left unchanged
% we minimize computations for clusters with little changed membership
    
    diff = find(mincenter ~= oldmincenter);
    diffj = unique([mincenter(diff);oldmincenter(diff)])';
    diffj = diffj(diffj > 0);
    
    if size(diff,1) < n/3 && iteration > 0
         for j = diffj
            plus = find(mincenter(diff) == j);
            minus = find(oldmincenter(diff) == j);
            oldpop = pop(j);
            pop(j) = pop(j) + size(plus,1) - size(minus,1);
            if pop(j) == 0 
                continue 
            end
            centers(j,:) = (centers(j,:)*oldpop + sum(data(diff(plus),:),1) - sum(data(diff(minus),:),1))/pop(j); 
        end
    else
        for j = diffj
            track = find(mincenter == j);
            pop(j) = size(track,1);
            if pop(j) == 0 
                continue 
            end
% it's correct to have mean(data(track,:),1) but this can make answer worse!
            centers(j,:) = mean(data(track,:),1);
        end
    end
    
    nchanged = size(diff,1) + skipestep;
    iteration = iteration+1;
    skipestep = 0;
    oldmincenter = mincenter;

%   difference = max(max(abs(oldcenters - centers)));
%   [iteration toc nchanged computed size(diffj,2)]
    %[iteration toc nchanged computed];
    total = total + computed;
end % while nchanged > 0

udist = calcdist(data,centers(mincenter,:));
quality = mean(udist);
q2 = mean(udist.^2);
%[iteration toc quality q2 total];

end

function distances = calcdist(data,center)
%  input: vector of data points, single center or multiple centers
% output: vector of distances

[n,~] = size(data);
[n2,~] = size(center);

% Using repmat is slower than using ones(n,1)
%   delta = data - repmat(center,n,1);
%   delta = data - center(ones(n,1),:);
% The following is fastest: not duplicating the center at all

if n2 == 1
    distances = sum(data.^2, 2) - 2*data*center' + center*center';
elseif n2 == n
    distances = sum( (data - center).^2 ,2);
else
    error('bad number of centers');
end

% Euclidean 2-norm distance:
distances = sqrt(distances);

% Inf-norm distance:
% distances = max(abs(distances),[],2);
end


%%

function [centers, mincenter, mindist, lower, computed] = anchors(firstcenter,k,data)
% choose k centers by the furthest-first method

[n,dim] = size(data);
centers = zeros(k,dim);
lower = zeros(n,k);
mindist = Inf*ones(n,1);
mincenter = ones(n,1);
computed = 0;
centdist = zeros(k,k);

for j = 1:k
    if j == 1
        newcenter = firstcenter;
    else
        [~,i] = max(mindist);
        newcenter = data(i,:);
    end

    centers(j,:) = newcenter;
    centdist(1:j-1,j) = calcdist(centers(1:j-1,:),newcenter);
    centdist(j,1:j-1) = centdist(1:j-1,j)';
    computed = computed + j-1;
    
    inplay = find(mindist > centdist(mincenter,j)/2);
    newdist = calcdist(data(inplay,:),newcenter);
    computed = computed + size(inplay,1);
    lower(inplay,j) = newdist;
        
%    other = find(mindist <= centdist(mincenter,j)/2);
%    if ~isempty(other)
%        lower(other,j) = centdist(mincenter(other),j) - mindist(other);
%    end    
        
    move = find(newdist < mindist(inplay));
    shift = inplay(move);
    mincenter(shift) = j;
    mindist(shift) = newdist(move);
end

%udist = calcdist(data,centers(mincenter,:));
%quality = mean(udist);
%q2 = mean(udist.^2);
%[k toc quality q2 computed]
%toc
end