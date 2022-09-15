function  A1 = KArchiveSave(A1,V,NI)
% Update archive

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Cheng He
    global Global;
    %% Delete duplicated solutions
    [~,index] = unique(decs(A1),'rows');
    Total     = A1(index);
    
    %% Select NI solutions for updating the models 
    if length(Total)>NI
        % Since the number of inactive reference vectors is smaller than
        % NI-mu, we cluster the solutions instead of reference vectors
        PopObj = objs(Total);
        PopObj = PopObj - repmat(min(PopObj,[],1),length(Total),1);
        Angle  = acos(1-pdist2(PopObj,V,'cosine'));
        [~,associate] = min(Angle,[],2);
        Via    = V(unique(associate)',:);
        Next   = zeros(1,NI);
        if size(Via,1) > NI
            [IDX,~] = kmeans(Via,NI);
            for i = unique(IDX)'
                current = find(IDX==i);
                if length(current)>1
                    best = randi(length(current),1);
                else
                    best = 1;
                end
                Next(i)  = current(best);
            end
        else
            % Cluster solutions based on objective vectors when the number
            % of active reference vectors is smaller than NI-mu
            [IDX,~] = kmeans(objs(Total),NI);
                for i   = unique(IDX)'
                    current = find(IDX==i);
                    if length(current)>1
                        best = randi(length(current),1);
                    else
                        best = 1;
                    end
                    Next(i)  = current(best);
                end
            A1 = [Total(Next),New];
        end
   else 
       A1 = Total;
   end
end       