function weight = WD(C, F, P, B, Cmax, Fmax, Pmax, Bmax, Cmin, Fmin, Pmin, Bmin )
% C: cost of service
% F: performance of network (SINR)
% P: power consumption
% B: bandwidth of network
    Nc = (C-Cmin) ./ (Cmax-Cmin);
    Nf = (F-Fmin) ./ (Fmax-Fmin);
    Np = (P-Pmin) ./ (Pmax-Pmin);
    Nb = (B-Bmin) ./ (Bmax-Bmin);
    
    mc = sum(Nc) / length(Nc);
    mf = sum(Nf) / length(Nf);
    mp = sum(Np) / length(Np);
    mb = sum(Nb) / length(Nb);
    
    sigma_c = sqrt(sum((Nc-mc) .^ 2) / (length(Nc)-1));
    sigma_f = sqrt(sum((Nf-mf) .^ 2) / (length(Nf)-1));
    sigma_p = sqrt(sum((Np-mp) .^ 2) / (length(Np)-1));
    sigma_b = sqrt(sum((Nb-mb) .^ 2) / (length(Nb)-1));
    
    phi_c = exp(-mc+sigma_c);
    phi_f = exp(-mf+sigma_f);
    phi_p = exp(-mp+sigma_p);
    phi_b = exp(-mb+sigma_b);
    phi = phi_c + phi_f + phi_p + phi_b;
    
    weight(1:4) = 0;
    weight(1) = phi_c / phi;
    weight(2) = phi_f / phi;
    weight(3) = phi_p / phi;
    weight(4) = phi_b / phi;
end