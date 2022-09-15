function Score = CalIGD(Population)
% <metric> <min>
% Inverted generational distance

%------------------------------- Reference --------------------------------
% C. A. Coello Coello and N. C. Cortes, Solving multiobjective optimization
% problems using an artificial immune system, Genetic Programming and
% Evolvable Machines, 2005, 6(2): 163-190.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------
    global Global
    PopDec   = decs(Population);
    PopObj   = eval([Global.Problem '.obj(PopDec)']);
    [PF, ~]  = eval([Global.Problem '.RefPoints()']);
    Distance = min(pdist2(real(PF),real(PopObj)),[],2);
    %Distance = min(pdist2(real(PopObj),real(PF)),[],2);
    Score    = mean(Distance);
end