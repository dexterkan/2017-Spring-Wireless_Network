x_ms(1:50) = 0;
y_ms(1:50) = 0;
theta = linspace(0,2*pi,7);
D = 500 / (3^0.5);
plot(D*cos(theta),D*sin(theta),'g-');
axis square;
hold on
plot([-300,300],[0,0],'b');
hold on
plot([0,0],[-300,300],'b');
hold on
plot(0,0,'s','MarkerFaceColor','k');
i = 0;
num = 1;
while i < 50
    x = 2*D*rand(1,2)-D;
    if(abs(x(1))+abs(x(2))/sqrt(3)) <= D && abs(x(2)) <= D*sqrt(3)/2
        x_ms(num) = x(1);
        y_ms(num) = x(2);
        num = num + 1;
        i = i + 1;
        hold on
        plot(x(1),x(2),'r*');
    end
end
hold off

title('location of the central BS and 50 MS');
xlabel('x-axis(meter)');
ylabel('y-axis(meter)');

%===============================================%

h_bs = 51.5;
h_ms = 1.5;
power_bs = 10^0.3;
g_trans = 10^1.4;
g_rev = 10^1.4;
power_rev(1:50) = 0; %in db
figure
for i = 1:50
    d = sqrt(x_ms(i)^2+y_ms(i)^2);
    power_rev(i) = 10 * log10((h_bs*h_ms)^2 / d^4 * power_bs * g_trans * g_rev);
    hold on
    plot(d,power_rev(i),'r*');
end
hold off

title('the recieve power of MS (in dB)');
xlabel('distance(in meter) between the BS and each mobile device');
ylabel('recieve power of the mobile device(in dB) in central BS');

%=========================================================================%

noise = 1.38 * (10^-23) * (273+27) * 10 * (10^6);
interference(1:50) = 0; 
power(1:50) = 0; % in Watt
SINR(1:50) = 0;

for i = 1:50
    d = sqrt(x_ms(i)^2+y_ms(i)^2);
    power(i) = (h_bs*h_ms)^2 / d^4 * power_bs * g_trans * g_rev;
end

for i = 1:50
    for j = 1:50
        if j == i 
            continue;
        end
        interference(i) = interference(i) + power(j);
    end
end
figure
for i = 1:50
    d = sqrt(x_ms(i)^2+y_ms(i)^2);
    SINR(i) = 10 * log10(power(i)/(noise+interference(i)));
    hold on
    plot(d,SINR(i),'r*');
end
hold off

title('SINR in dB');
xlabel('distance(in meter) between the BS and each mobile device');
ylabel('SINR of the mobile device(in dB) in central BS');
