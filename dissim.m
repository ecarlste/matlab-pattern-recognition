function Y = dissim(X)

[m, n] = size(X);

Y = zeros(m);

for i = 1:m
    for j = i+1:m
        v = X(i,:) - X(j,:);
        Y(i,j) = norm(v);
        Y(j,i) = Y(i,j);
    end
end