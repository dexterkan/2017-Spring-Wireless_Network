theta = linspace(0,2*pi,7);
D = 500 / (3^0.5);
x_center(1:19) = 0;
y_center(1:19) = 0;
x_ms(1:100) = 0;
y_ms(1:100) = 0;
xms(1:100) = 0;
yms(1:100) = 0;
position_begin(1:100) = 0;
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
all = randperm(19);
plus(1:5) = all(1:5);
device = 5;
num = 1;
for i = 1:19
    for p = 1:5
        if( i == plus(p) )
            device = 6;
        end
    end
    j = 0;
    while j < device
        x = 2*D*rand(1,2)-D;
        if(abs(x(1))+abs(x(2))/sqrt(3)) <= D && abs(x(2)) <= D*sqrt(3)/2
            x_ms(num+j) = x(1);
            y_ms(num+j) = x(2);
            xms(num+j) = x(1)+x_center(i);
            yms(num+j) = x(2)+y_center(i);
            position_begin(num+j) = i;
            j = j + 1;
            hold on
            plot(x(1)+x_center(i),x(2)+y_center(i),'r*');
        end
    end
    num = num + device;
    device = 5;
end

hold off

title('location of 19 BS / 100 MS and thier IDs');
xlabel('x-axis(meter)');
ylabel('y-axis(meter)');

%======================================================%
h_bs = 51.5;
h_ms = 1.5;
power_ms = 10^-0.7;
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
position = zeros(100,1000);
noise = 1.38 * (10^-23) * (273+27) * 10 * (10^6);
T(1:100) = 0;
S(1:100) = 0;
A(1:100) = 0;

for t = 1:900
    for device = 1:100
        if( T(device) == 0 )
            T(device) = unidrnd(maxT);
            S(device) = 1 + 14*rand();
            A(device) = 2*pi*rand();
        end
        xms(device) = xms(device) + S(device)*cos(A(device));
        yms(device) = yms(device) + S(device)*sin(A(device));
        d_min = 0;
        check = 0;
        for j = 1 : 19
            dc = sqrt((xms(device)-x_center(j))^2+(yms(device)-y_center(j))^2);
            if( j == 1 ) 
                d_min = dc;
                check = j;
            end
            if( dc < d_min ) 
                d_min = dc;
                check = j;
            end
        end
        
        if(abs(xms(device)-x_center(check))+abs(yms(device)-y_center(check))/sqrt(3)) > D || abs(yms(device)-y_center(check)) > D*sqrt(3)/2
           xms(device) = 0 - xms(device);
           yms(device) = 0 - yms(device); 
        end
        T(device) = T(device) - 1;
    end
    
    for device = 1:100
        SINR_max = 0;
        for i = 1:19
            power(1:100) = 0;
            for j = 1:100
                d = sqrt((xms(j)-x_center(i))^2+(yms(j)-y_center(i))^2);
                power(j) = (h_bs*h_ms)^2 / d^4 * power_ms * g_trans * g_rev;
            end
            interference = 0;
            for j = 1:100
                if j == device 
                    continue
                end
                interference = interference + power(j);
            end
            SINR = power(device)/(noise+interference);
            if( SINR > SINR_max ) 
                SINR_max = SINR;
                position(device,t) = i;
            end
        end
    end
end
handover = zeros(900*100,4);
count = 0;
ht = 1;
for device = 1:100
    checkp = position_begin(device);
    for p = 1:900
        if position(device,p) ~= checkp
            count = count + 1;
            handover(ht,1) = device;
            handover(ht,2) = p;
            handover(ht,3) = checkp;
            handover(ht,4) = position(device,p);
            checkp = position(device,p);
            ht = ht + 1;
        end
    end
end
['# of handoff event = ' , num2str(count)]