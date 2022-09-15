function [Objs,MSE] = kriging_cal(Decs, Mds)
    global Global;
    %% parameter set
    [N, ~] = size(Decs);
    Objs   = zeros(N, Global.M);
    MSE    = zeros(N, Global.M);
    %% calculate for evr model && return the average predict
    for j=1:Global.M
        [Objs(:,j), MSE(:,j)] = predictor(Decs, Mds(j).md);
    end
end