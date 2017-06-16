theta = linspace(0,2*pi,7);
D = 500 / (3^0.5);
x_ms(1:50) = 0;
y_ms(1:50) = 0;
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
hold on
plot(D*cos(theta),D*sin(theta),'g-'); % only plot central cell
axis square;
hold on
plot([-300,300],[0,0],'b');
hold on
plot([0,0],[-300,300],'b');

i = 0;
num = 1;
while i < 50
    x = 2*D*rand(1,2)-D;
    if(abs(x(1))+abs(x(2))/sqrt(3)) <= D && abs(x(2)) <= D*sqrt(3)/2
        x_ms(num+i) = x(1);
        y_ms(num+i) = x(2);
        i = i + 1;
        hold on
        plot(x(1),x(2),'r*');
        end
end
hold off
title('location of central BS and 50 MS in central cell');
xlabel('x-axis(meter)');
ylabel('y-axis(meter)');
%=====================================================%

% interference comes from other BSs
Temperature = 27 + 273;
bandwidth = 10*(10^6);
h_bs = 51.5;
h_ms = 1.5;
power_bs = 10^0.3;
power_ms = 10^-3;
g_trans = 10^1.4;
g_recv = 10^1.4;

SINR(1:50) = 0;
noise = 1.38*(10^-23)*Temperature*(bandwidth/50); %50MS equally divide bandwidth

for device = 1:50
    interference = 0;
    for bs = 1:19
        if bs == 3
            continue
        end
        d = sqrt((x_ms(device)-x_center(bs))^2+(y_ms(device)-y_center(bs))^2);
        interference = interference + (h_bs*h_ms)^2 / d^4 * power_bs * g_trans * g_recv;
    end
    d_central = sqrt(x_ms(device)^2+y_ms(device)^2);
    power = (h_bs*h_ms)^2 / d_central^4 * power_bs * g_trans * g_recv;
    SINR(device) = power / ( interference + noise );
end

C(1:50) = 0; % Shannon Capacity

figure
for device= 1:50
    d_ms = sqrt(x_ms(device)^2+y_ms(device)^2);
    C(device) = (bandwidth/50)*log2(1+SINR(device));
    hold on
    plot(d_ms,C(device),'r*');
end
hold off

title('Shannon Capacity');
xlabel('distance(in meter) between the BS and each mobile device');
ylabel('Shannon Capacity of the mobile device in central BS');

%============================================%
T = 1000;
buffer = 6 * 10^6;
C_in_order = sort(C);
Lambda_l = floor(C_in_order(1));
Lambda_m = floor((C_in_order(25)+C_in_order(26))/2);
Lambda_h = floor(C_in_order(50));
in_buffer(1:3) = 0;
all_traffic(1:3) = 0;
loss(1:3) = 0;

% Lambda_l
X_l = Lambda_l * 50 ;
for t = 1:T 
    in_buffer(1) = in_buffer(1) + X_l;
    for device = 1:50
        traffic_arrival = 0;
        all_traffic(1) = all_traffic(1) + X_l;
        traffic_arrival = exp(-Lambda_l) * (Lambda_l^X_l) / factorial(X_l);
        if traffic_arrival < C(device)
            in_buffer(1) = in_buffer(1) - traffic_arrival;
        else
            in_buffer(1) = in_buffer(1) - C(device);
        end
    end
    
    if in_buffer(1) > buffer
        loss(1) = loss(1) + in_buffer(1) - buffer;
        in_buffer(1) = buffer;
    end
end

% Lambda_m
X_m = Lambda_m * 50 ;
for t = 1:T 
    in_buffer(2) = in_buffer(2) + X_m;
    for device = 1:50
        traffic_arrival = 0;
        all_traffic(2) = all_traffic(2) + X_m;
        traffic_arrival = exp(-Lambda_m) * (Lambda_m^X_m) / factorial(X_m);
        if traffic_arrival < C(device)
            in_buffer(2) = in_buffer(2) - traffic_arrival;
        else
            in_buffer(2) = in_buffer(2) - C(device);
        end
    end
    
    if in_buffer(2) > buffer
        loss(2) = loss(2) + in_buffer(2) - buffer;
        in_buffer(2) = buffer;
    end
end
     
% Lambda_h
X_h = Lambda_h * 50 ;
for t = 1:T 
    in_buffer(3) = in_buffer(3) + X_h;
    for device = 1:50
        traffic_arrival = 0;
        all_traffic(3) = all_traffic(3) + X_h;
        traffic_arrival = exp(-Lambda_h) * (Lambda_h^X_h) / factorial(X_h);
        if traffic_arrival < C(device)
            in_buffer(3) = in_buffer(3) - traffic_arrival;
        else
            in_buffer(3) = in_buffer(3) - C(device);
        end
    end
    
    if in_buffer(3) > buffer
        loss(3) = loss(3) + in_buffer(3) - buffer;
        in_buffer(3) = buffer;
    end
end

loss_prob(1:3) = 0;

for i = 1:3
    loss_prob(i) = loss(i) / all_traffic(i); 
end

Lambda = [ Lambda_l , Lambda_m , Lambda_h ];

figure
bar(loss_prob,0.5);
set(gca,'XTickLabel',{'Lambda_l','Lambda_m','Lambda_h'});
title('bits loss probability(Poisson)');
xlabel('traffic load');
ylabel('probability');