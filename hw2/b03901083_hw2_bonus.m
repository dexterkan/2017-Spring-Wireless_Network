x_ms(1:50*19) = 0;
y_ms(1:50*19) = 0;
xms(1:50*19) = 0;
yms(1:50*19) = 0;
theta = linspace(0,2*pi,7);
D = 500 / (3^0.5);
x_center(1:19) = 0;
y_center(1:19) = 0;
%====================================%
for i = 1:5
    y_center(i) = -1000 + 500*(i-1);
end
for i = 6:9
    x_center(i) = 1.5*D;
    y_center(i) = -750 + 500*(i-6);
end
for i = 10:13
    x_center(i) = -1.5*D;
    y_center(i) = -750 + 500*(i-10);
end
for i = 14:16
    x_center(i) = 3*D;
    y_center(i) = -500 + 500*(i-14);
end
for i = 17:19
    x_center(i) = -3*D;
    y_center(i) = -500 + 500*(i-17);
end
%==========================================%
for i = 1:19
    hold on
    plot(D*cos(theta)+x_center(i),D*sin(theta)+y_center(i),'g-');
    hold on
    plot(x_center(i),y_center(i),'s','MarkerFaceColor','k');
end
axis square;
hold on
plot([-1250,1250],[0,0],'b');
hold on
plot([0,0],[-1250,1250],'b');

for i = 1:19
    j = 0;
    num = 1 + 50*(i-1);
    while j < 50
        x = 2*D*rand(1,2)-D;
        if(abs(x(1))+abs(x(2))/sqrt(3)) <= D && abs(x(2)) <= D*sqrt(3)/2
            x_ms(num) = x(1);
            y_ms(num) = x(2);
            xms(num) = x(1)+x_center(i);
            yms(num) = x(2)+y_center(i);
            num = num + 1;
            j = j + 1;
            hold on
            plot(x(1)+x_center(i),x(2)+y_center(i),'r*');
        end
    end
end
hold off

title('location of all BS and all MS');
xlabel('x-axis(meter)');
ylabel('y-axis(meter)');
%======================================%

h_bs = 51.5;
h_ms = 1.5;
power_ms = 10^-0.7;
g_trans = 10^1.4;
g_rev = 10^1.4;
power_rev(1:50*19) = 0; %in db
figure
for i = 1:50*19
    d = sqrt(x_ms(i)^2+y_ms(i)^2);
    power_rev(i) = 10 * log10((h_bs*h_ms)^2 / d^4 * power_ms * g_trans * g_rev);
    hold on
    plot(d,power_rev(i),'r*');
end

title('the recieve power of BS (in dB)');
xlabel('distance(in meter) between all BS and all mobile device');
ylabel('recieve power of the mobile device(in dB) in all BS');

%============================================================================%
noise = 1.38 * (10^-23) * (273+27) * 10 * (10^6);
interference(1:50*19) = 0; 
power(1:50*19) = 0; % in Watt
SINR(1:50*19) = 0;

for i = 1:50*19
    d = sqrt(x_ms(i)^2+y_ms(i)^2);
    power(i) = (h_bs*h_ms)^2 / d^4 * power_ms * g_trans * g_rev;
end

for c = 1:19
    for i = 1:50*19
        for j = 1:50*19
            if j == i 
                continue;
            end
            d = sqrt((xms(j)-x_center(c))^2+(yms(j)-y_center(c))^2);
            interference(i) = interference(i) + (h_bs*h_ms)^2 / d^4 * power_ms * g_trans * g_rev;
        end
    end
end

figure
for i = 1:50*19
    d = sqrt(x_ms(i)^2+y_ms(i)^2);
    SINR(i) = 10 * log10(power(i)/(noise+interference(i)));
    hold on
    plot(d,SINR(i),'r*');
end
hold off
title('SINR in dB');
xlabel('distance(in meter) between all BS and each mobile device');
ylabel('SINR of the mobile device(in dB) in all BS');
