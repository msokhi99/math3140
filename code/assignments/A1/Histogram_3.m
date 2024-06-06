% Histogram Q3
histBins = [1 2 3; 1 2 2;2 2 1];
x = randn(1000, 1);
edges = [-10 -2:0.25:2 10];

y = 200*randn(100, 1);

for k = 1 : length(histBins)-1
    indexes = y > histBins(k) & y <= histBins(k+1);
    binByBinSums(k) = sum(y(indexes));
end

Total_Energy = sum(y(indexes))* sum(x);

figure
h = histogram(x, edges);
title('Histogram of energy specific parameters x')
figure
zz = histogram(y);
title('Histogram of energy specific parameters y')