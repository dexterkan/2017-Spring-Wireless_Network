function [vec_x , vec_y] = draw_hex2(x0 , y0 , length , ISD)
    ang = 0 : pi/3 : 2*pi;
    vec_x = length * cos(ang)+x0;
    vec_y = length * sin(ang)+y0;
    
    plot(vec_x , vec_y , 'B');
    %scatter(x0 , y0 , 'filled' ,'G');
end