function Objs = RBFN_cal(Decs, Rnets, M)
    %%
    global Global;
    [N, ~] = size(Decs);
    Objs = zeros(N, M);
    %% calculate for evr model && return the average predict
    kernal_name = Rnets.name;
    eval(['Z = ', kernal_name, '(Decs, Rnets.centers, Rnets.sigma);']);
    Z    = [Z, ones(size(Z, 1), 1)];    
    Objs = Z*Rnets.weight+Objs;
end