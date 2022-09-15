function score = Cal_IGDP(Population)
% <min>
% Inverted generational distance +


%------------------------------- Copyright --------------------------------
% Copyright (c) 2021 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    PopDec = decs(Population);
    PopObj = eval([Global.Problem '.obj(PopDec)']);
    [PF, ~]= eval([Global.Problem '.RefPoints()']);
    [x,z]  = size(PopObj);
    y      = size(PF,1);
    va     = zeros(x,z);
    distance = zeros(1,y);
    for i = 1:y
        obj = repmat(PF(i,:),x,1);
        distance(i) = min(sqrt(sum((max((PopObj - obj),va)).^2,2)));
    end
    score = mean(distance);
end