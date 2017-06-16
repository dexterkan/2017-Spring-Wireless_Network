function theta = cal_orientation(y1 , x1 , y2 , x2)
    theta = pi/2 - atan(cos(y2)*sin(x2-x1) / (cos(y1)*sin(y2) - sin(y1)*cos(y2)*cos(x2-x2)));
end