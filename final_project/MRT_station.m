classdef MRT_station
    properties
        pos_x;
        pos_y;
        id
    end
    methods
        function M = MRT_station(x , y , id)
            M.pos_x = x;
            M.pos_y = y;
            M.id = id;
        end
    end
end