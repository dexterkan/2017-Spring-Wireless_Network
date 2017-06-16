%% parameter setting
base_num = 19;
extend_num = 6;
micro_BS = cell(1 , base_num);
WIFI = cell(1 , 24);
extend_BS = cell(extend_num , base_num);
ISD = 2000;
length = ISD/sqrt(3);
BS_X = length * [0, 0, -1.5, -1.5, 0, 1.5, 1.5, 0, -1.5, -3, -3, -3, -1.5, 0, 1.5, 3, 3, 3, 1.5] ;
BS_Y = ISD * [0, 1,  0.5, -0.5, -1, -0.5, 0.5, 2, 1.5, 1, 0, -1, -1.5, -2, -1.5, -1, 0, 1, 1.5] ;
macro_ISD = 10000;
macro_length = macro_ISD/sqrt(3);
ISD_WIFI = 35;
length_WIFI = ISD_WIFI/sqrt(3);
m_h = 7.5;
b_h = 51.5;
WIFI_h = 9;
temp = 300;

%% map construct
pos_x = [121.579430 , 121.573145 , 121.568102 , 121.558201 , 121.557052 , 121.558791 , 121.553004 , 121.543437 , 121.543584 ...
         121.543757 , 121.544040 , 121.544226 , 121.551995 , 121.546894 , 121.555592 , 121.567212 , 121.575079 , 121.585064 ...
         121.594407 , 121.602143 , 121.607620 , 121.611452 , 121.615952 , 121.617852];%longitude
pos_y = [24.998259 , 24.998240 , 24.998585 , 24.999389 , 25.005243 , 25.018535 , 25.023739 , 25.026124 , 25.032928 ...
         25.040958 , 25.052241 , 25.060848 , 25.063004 , 25.079476 , 25.084853 , 25.082148 , 25.080031 , 25.078530 ...
         25.083660 , 25.083841 , 25.072504 , 25.067123 , 25.059904 , 25.055405];%latitude

x = zeros(1 , 24);
y = zeros(1 , 24);
MRT_s = cell(1 , 24);
for i = 1:23
    x(1 , i+1) = great_circle(pos_y(1 , i) , pos_x(1 , i) , pos_y(1 , i) , pos_x(1 , i+1));
    y(1 , i+1) = great_circle(pos_y(1 , i) , pos_x(1 , i) , pos_y(1 , i+1) , pos_x(1 , i));
end
mrt_x = zeros(1 , 24);
mrt_y = zeros(1 , 24);
mrt_x(1 , 1) = 400;
mrt_y(1 , 1) = 450;
for i = 1:23
    if pos_x(1 , i+1) > pos_x(1 , i)
        mrt_x(1 , i+1) = mrt_x(1 , i) + x(1 , i+1);
    else mrt_x(1 , i+1) = mrt_x(1 , i) - x(1 , i+1);
    end
    if pos_y(1 , i+1) > pos_y(1 , i)
        mrt_y(1 , i+1) = mrt_y(1 , i) + y(1 , i+1);
    else mrt_y(1 , i+1) = mrt_y(1 , i) - y(1 , i+1);
    end
end
for_orientation = zeros(1 , 24); % forward direction
%{
for i = 1:23
    for_orientation(1 , i) = atan((mrt_y(1 , i+1) - mrt_y(1 , i) )/ ((mrt_x(1 , i+1) - mrt_x(1 , i) ))) + pi;%denote ith to (i+1)th
    back_orientation(1 , i+1) = for_orientation(1 , i) - pi;
end

for i = 1:24
    MRT_s{1 , i} = MRT_station(mrt_x(1 , i) , mrt_y(1 , i) , i);
end
%}
scatter(mrt_x(1 , :) , mrt_y(1 , :) , 'r');
hold on
for i = 1:base_num
    [x_vec_tmp , y_vec_tmp] = draw_hex2(BS_X(i) , BS_Y(i) , length , ISD);
    scatter(BS_X(i) , BS_Y(i) , 'filled' ,'G');
    micro_BS{1 , i} = BaseStation(i , BS_X(i) , BS_Y(i) , x_vec_tmp , y_vec_tmp);
    text(micro_BS{1 , i}.pos_x, micro_BS{1,i}.pos_y, int2str(i));
end

extend_center = zeros(2 , extend_num);
for i = 1:extend_num
    tmp_angle = 0 : pi/3 : 2*pi;
    extend_center(1 , i) = (-7.5*length)*cos(tmp_angle(i)) - ISD/2*sin(tmp_angle(i));
    extend_center(2 , i) = (-7.5*length)*sin(tmp_angle(i)) + ISD/2*cos(tmp_angle(i));    
    for j = 1:base_num
        [x_vec_tmp , y_vec_tmp] = draw_hex2(BS_X(j) + extend_center(1 , i) , BS_Y(j) + extend_center(2 , i), length , ISD);
        extend_BS{i , j} = BaseStation(i , BS_X(j) + extend_center(1 , i) , BS_Y(j) + extend_center(2 , i) , x_vec_tmp , y_vec_tmp);
    end
end

for i = 1:24
    [x_vec_tmp , y_vec_tmp] = draw_hex2(mrt_x(1 , i) , mrt_y(1 , i) , length_WIFI , ISD_WIFI);
    WIFI{1 , i} = BaseStation(i , mrt_x(1 , i) , mrt_y(1 , i) , x_vec_tmp , y_vec_tmp);
    MRT_s{1 , i} = MRT_station(mrt_x(1 , i) , mrt_y(1 , i) , i);
end