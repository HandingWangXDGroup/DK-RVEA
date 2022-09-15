function [Population, MemoryPop] = MNOptimal(Population, RandPop, MemoryPop)
    global Global;
    %% nsgaii
    [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Global.N);
    MatingPool = TournamentSelection(2,Global.N,FrontNo,-CrowdDis);
    OffDec     = GA(decs(Population(MatingPool)));
    OffObj     = eval([Global.Problem '.obj(OffDec)']);
    Offspring  = PopStruct(OffDec, OffObj);
    Global.Evaluated = Global.Evaluated + Global.N;
    Population = EnvironmentalSelection([Population,Offspring], Global.N);
    
    %% Update the memory popualtion
    AddPop = [Population, RandPop];
    [~,FrontNo,~] = EnvironmentalSelection(AddPop,Global.N);
    SPop = AddPop(FrontNo==1);
    SDec = decs(SPop); SObj = objs(SPop);
    Ns   = length(SPop);
    for i=1:Ns
        CurDec = SDec(i,:); CurObj = SObj(i,:);
        [~, MinID] = min(pdist2(CurDec, SDec));
        NearObj    = SObj(MinID,:);
        if all((CurObj-NearObj)<0)
            SDec(i,:) = CurDec; SObj(i,:) = CurObj;
        end
    end
end