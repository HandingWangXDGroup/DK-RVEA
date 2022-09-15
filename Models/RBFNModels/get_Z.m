function Z = get_Z(PopDec, Rname, Rnets)
    eval(['Z = ', Rname, '(PopDec, Rnets.centers, Rnets.sigma);']);
    Z = [Z, ones(size(Z, 1), 1)];
end