function t_ray = two_ray(h_t , h_r , d)
    t_ray = (h_t * h_r)^2 ./ (d .^ 4);
end