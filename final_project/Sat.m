function satisfication = Sat(C, F, P, B, C_p, F_p, P_p, B_p, w)
    satisfication = w(1)*(C_p-C) / C + w(2)*(F_p-F) / F + w(3)*(P_p-P) / P + w(4)*(B_p-B) / B;
end