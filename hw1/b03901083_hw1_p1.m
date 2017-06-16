h_b = 51.5;
h_m = 1.5;
power_b = 10^0.3;
g_trans = 10^1.4;
g_rev = 10^1.4;
distance = 1:5000;

power_rev(1:5000) = 0; %power in dB
%hw1 1-1
for d = 1:5000
    power_rev(d) = 10 * log10((h_b*h_m)^2 / d^4 * power_b * g_trans * g_rev);
end

plot( distance , power_rev );
title('recieve power without shadowing');
xlabel('distance(in meter) between the BS and mobile device');
ylabel('recieve power of the mobile device(in dB)');
%hw1 1-1 end

%hw1 1-2
noise = 1.38 * (10^-23) * (273+27) * 10 * (10^6);
SINR(1:5000) = 0; %SINR in dB

for d = 1:5000
    power_rev(d) = (h_b*h_m)^2 / d^4 * power_b * g_trans * g_rev;
    SINR(d) = 10 * log10(power_rev(d)/noise);
end

figure
plot( distance , SINR );
title('SINR without shadowing');
xlabel('distance(in meter) between the BS and mobile device');
ylabel('SINR of the mobile device(in dB)');
%hw1 1-2 end