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
    text(x_center(i),y_center(i),num2str(i))
end
axis square;
hold on
plot([-1250,1250],[0,0],'b');
hold on
plot([0,0],[-1250,1250],'b');

hold off

title('location of 19 BS and thier IDs');
xlabel('x-axis(meter)');
ylabel('y-axis(meter)');

%==========================================%
h_bs = 51.5;
h_ms = 1.5;
power_bs = 10^0.3;
g_trans = 10^1.4;
g_rev = 10^1.4;
%=========================================%
ms_x = 250;
ms_y = 0;

ang_min = 0;
ang_max = 2*pi;

minSpeed = 1;
maxSpeed = 15;

minT = 1;
maxT = 6;

%========================================%
position_begin = 3;
position(1:1000) = 0;
noise = 1.38 * (10^-23) * (273+27) * 10 * (10^6);
t = 0;
T = 0;
S = 0;
A = 0;
while t <= 900 
    T = unidrnd(maxT);
    S = 1 + 14*rand();
    A = 2*pi*rand();
    
    for i = 1:T
        d_min = 0;
        check = 0;
        SINR_max = 0;
        ms_x = ms_x + S*cos(A);
        ms_y = ms_y + S*sin(A);
        for j = 1 : 19
            d = sqrt((ms_x-x_center(j))^2+(ms_y-y_center(j))^2);
            if( j == 1 ) 
                d_min = d;
                check = j;
            end
            if( d < d_min ) 
                d_min = d;
                check = j;
            end
        end
        
        if(abs(ms_x-x_center(check))+abs(ms_y-y_center(check))/sqrt(3)) > D || abs(ms_y-y_center(check)) > D*sqrt(3)/2
           ms_x = 0 - ms_x;
           ms_y = 0 - ms_y; 
        end
        
        for j = 1:19
            d = sqrt((ms_x-x_center(j))^2+(ms_y-y_center(j))^2);
            power = (h_bs*h_ms)^2 / d^4 * power_bs * g_trans * g_rev;
            SINR = power/noise;
            if( SINR > SINR_max ) 
                SINR_max = SINR;
                position(t+i) = j;
            end
        end
    end
    
    t = t + T;
end
handover = zeros(900,3);
checkp = position_begin;
count = 0;
ht = 1;
for p = 1:900
    if position(p) ~= checkp
        count = count + 1;
        handover(ht,1) = p;
        handover(ht,2) = checkp;
        handover(ht,3) = position(p);
        checkp = position(p);
        ht = ht + 1;
    end
end
['# of handoff event = ' , num2str(count)]