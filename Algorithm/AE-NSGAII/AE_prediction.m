function [ini_solution] = AE_prediction(curr_NDS, his_NDS, curr_POS, NP)
    % Prediction via Denoising Autoencoding in AE-MOEA for solving DMOP.
    
    % curr_NDS and his_NDS denote N_l number of non-dominated solutions obtained in the current and previous time windows, respectively. 
    % Both in the form of N_l*d matrix. 
    % N_l is the number of individual, d is the variable dimension of the given DMOP, and NP denotes the population size of the evolutionary solver. 
    
    % curr_POS is the POS solutions from current time window (the obtained non-dominated solution set). 
    
    % output is the predicted initial solutions of the evolutionary search for new time window.
    
    [d, N_l] = size(curr_NDS');
    
    Q = his_NDS*his_NDS';
    P = curr_NDS*his_NDS';
    
    lambda = 1e-5;
    reg = lambda*eye(N_l);
    reg(end,end) = 0;
    M = P/(Q+reg);% the learned matrix M.
    
    varM = M*his_NDS;
    for i=1:N_l
        for j=1:d
            var(i,j) = (curr_NDS(i,j)-varM(i,j)).^2;
        end
    end
    v = mean2(var);
    
    pre_solution = M*curr_POS+v;
    curr_len = size(pre_solution, 1);
    if curr_len > NP/2
        ini_solution = pre_solution(:,1:NP/2);
    else 
        ini_solution = pre_solution;
    end
end