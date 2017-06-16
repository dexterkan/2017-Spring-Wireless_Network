classdef BaseStation
    properties
        id
        pos_x  
        pos_y  
        x_vec     
        y_vec
        r_power
    end
    methods
        function BS = BaseStation(index , x , y , xv , yv)
            BS.id = index;
            BS.pos_x = x;
            BS.pos_y = y;
            BS.x_vec = xv;
            BS.y_vec = yv;
        end
    end
end
