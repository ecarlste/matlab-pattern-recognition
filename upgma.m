function M = upgma(X)
% cell array to store the dissimilarity matrix during each clustering step
M = {X};

%% initialization
[m, n] = size(X);

clusters = cell(m,1);

for i = 1:m
    clusters{i} = i;
end

indices = 1:m;

%% build a cluster -- done every step
% create a temp copy of X so that we can easily find the minimum value
temp = X;

while length(clusters) > 2
    % set the diagonal to the maximum double value to enable minimum value search
    i_diagonal = logical(eye(size(temp)));
    temp(i_diagonal) = realmax('double');

    % find the minimum value in the matrix, and keep track of the row,column
    [w, min_cols] = min(temp);
    [w, min_row] = min(w);
    min_col = min_cols(min_row);

    clusters_to_merge = sort([min_row min_col]);

    % create the new slice index
    % indices = indices(indices != min_col & indices != min_row);
    slice = setdiff(1:size(temp, 1), clusters_to_merge(end));

    % get rid of the rows and columns in the dissimilarity matrix that correspond
    % to the two clusters being merged
    temp = temp(slice, slice);

    % merge the clusters
    new_cluster = sort([clusters{min_row} clusters{min_col}]);
    clusters = clusters(slice);
    clusters(clusters_to_merge(1)) = new_cluster

    % now that the new cluster is formed, we need to add a row and column for the
    % cluster dissimilarity values
    for i = setdiff(1:size(temp, 1), clusters_to_merge(1))
        % determine the distance between cluster{i} and cluster{clusters_to_merge(1)}
        distance = 0;
        for u = clusters{clusters_to_merge(1)}
            for v = clusters{i}
                distance = distance + X(u,v);
            end
        end
        count = length(clusters{i}) * length(clusters{clusters_to_merge(1)});
        distance = distance / count;
        
        % save the newly found distance to the temp matrix
        temp(i, clusters_to_merge(1)) = distance;
        temp(clusters_to_merge(1), i) = distance;
    end

    % set the diagonal back to zero before we finish.
    temp(logical(eye(size(temp)))) = 0;

    M(end+1) = temp;
end