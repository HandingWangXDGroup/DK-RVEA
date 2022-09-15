function  A1 = KHisUpdataArchive(A1,New,V,mu,NI, TransFlag)
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
    All       = [decs(A1);decs(New)];
    [~,index] = unique(All,'rows');
    ALL       = [A1,New];
    Total     = ALL(index);
    
    %% Select NI solutions for updating the models 
	if length(Total)>NI
        [~,active] = NoActive(objs(New),V);
        Vi         = V(setdiff(1:size(V,1),active),:);
        % Select the undeplicated solutions without re-evaluated
        % solutions
        index = ismember(decs(Total),decs(New),'rows');
        Total = Total(~index);
        % Since the number of inactive reference vectors is smaller than
        % NI-mu, we cluster the solutions instead of reference vectors
        PopObj = objs(Total);
        PopObj = PopObj - repmat(min(PopObj,[],1),length(Total),1);
        Angle  = acos(1-pdist2(PopObj,Vi,'cosine'));
        [~,associate] = min(Angle,[],2);
        Via    = Vi(unique(associate)',:);
        Next   = zeros(1,NI-mu);
        if size(Via,1) > NI-mu
            [IDX,~] = kmeans(Via,NI-mu);
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
            [IDX,~] = kmeans(objs(Total),NI-mu);
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
   
    %% Delete the HisAddData if only subobjs are repeated
    if length(TransFlag)>1 && any(TransFlag==1)
        Addidx = find(TransFlag==1);
        for j=Addidx
            NA1    = length(A1);
            AddPop = Global.AddData{j};
            if length(AddPop) > 10*Global.D-NA1 && 10*Global.D-NA1>0
                PopObj = objs(AddPop);
                OneObj = PopObj(:,j);
                [IDX,~]= kmeans(OneObj,10*Global.D-NA1);
                Next   = zeros([1,10*Global.D-NA1]);
                for i=unique(IDX)'
                    current = find(IDX==i);
                    if length(current)>1
                        best = randi(length(current),1);
                    else
                        best = 1;
                    end
                    Next(i)  = current(best);
                end
                Global.AddData{j} = AddPop(Next);
            end
        end
    end
end       