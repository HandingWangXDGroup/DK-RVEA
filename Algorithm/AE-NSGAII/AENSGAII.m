function AENSGAII
    global Global
    Global.NR = 1;

    PopDec = RandSamp(Global.N);
    PopObj = eval([Global.Problem '.obj(PopDec)']);
    Population = PopStruct(PopDec,PopObj);
    [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,length(Population)); 
    while TerminateMN()
        if Global.Evaluated < (Global.NR*Global.T) || Global.Evaluated==0
            MatingPool = TournamentSelection(2,length(Population),FrontNo,-CrowdDis);
            OffDec     = GA(decs(Population(MatingPool)));
            OffObj     = eval([Global.Problem '.obj(OffDec)']);
            Global.Evaluated = Global.Evaluated + Global.N;
            Offspring  = PopStruct(OffDec,OffObj);
            [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Global.N);
        else
            AllNDs(Global.NR).NDs = Population(find(FrontNo==1));
            MNData(Population);  
            if Global.NR >1
                Population = PreAE(AllNDs, Population);
            else
                PopDec = RandSamp(Global.N);
                PopObj = eval([Global.Problem '.obj(PopDec)']);
                Population = PopStruct(PopDec,PopObj);
                [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,length(Population)); 
            end
            [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,length(Population)); 
            Global.NR         = Global.NR+1;    
        end
    end
end