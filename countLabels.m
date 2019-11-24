function [T] = countLabels(Y, names)
%Table of histogram
labels = unique(Y);
num_unique = length(labels);
count = zeros(num_unique,1);
for i=1:length(Y)
    idx = find(labels==Y(i));
    count(idx) = count(idx) +1;
end
T = table(names', labels, count);
end

