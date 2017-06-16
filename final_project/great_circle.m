function distance = great_circle(y1 , x1 , y2 , x2)
% y是緯度,x是經度
    
    R = 6378137; %radius of earth
    
    distance = R*acos( sin(y1)*sin(y2) + cos(y1)*cos(y2)*cos(x2-x1))*pi/180;
    

end