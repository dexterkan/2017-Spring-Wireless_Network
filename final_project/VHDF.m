function network = VHDF(C, F, P, B, w)
% C: cost of service
% S: security of network
% F: performance of network (SINR)
% P: power consumption
% B: bandwidth of network
% w: weight
    quality = 0;
    N = 0;
    for i = 1:length(C)
        q = w(1)*(1/C(i)) / max(1./C) + w(2)*F(i) / max(F) + w(3)*(1/P(i)) / max(1./P) + w(4)*B(i) / max(B);
        if q > quality
            quality = q;
            N = i;
        end
    end
    network = N;
end