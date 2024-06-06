% Test For Variance For 2 Populations:

P_1 = rand(49,1);
P_2 = rand(49,1);
nbins = 50;
sumP1 = 0;
sumP2 = 0;
for i = 1:length(P_1)
    sumP1 = sumP1 + P_1(i);
end

M_1 = sumP1/length(P_1);
sumP11 = 0;

for i = 1:length(P_1)
    sumP11 = sumP11 + (P_1(i) - M_1)^2;
end

V_1 = sumP11/length(P_1);

for i = 1:length(P_2)
    sumP2 = sumP2 + P_2(i);
end

M_2 = sumP2 / length(P_2);
sumP12 = 0;

for i = 1:length(P_2)
    sumP12 = sumP12 + (P_2(i) - M_2)^2;
end

V_2 = sumP12/length(P_2);

disp(V_1)
disp(V_2)

difference = V_1 - V_2;

disp(difference)


