function MNSGA()
    global Global;
    %% Generate the reference points and population
    PopDec       = RandSamp(Global.N);
    PopObj       = eval([Global.Problem '.obj(PopDec)']);
    Global.Evaluated = Global.Evaluated + Global.N;
    Population   = PopStruct(PopDec, PopObj);
    
    MemoryPopDec = RandSamp(Global.N/2);
    MemoryPopObj = eval([Global.Problem '.obj(MemoryPopDec)']);
    MemoryPop    = PopStruct(MemoryPopDec,MemoryPopObj);
    Global.Evaluated = Global.Evaluated + Global.N/2;
    
    RandPopDec       = RandSamp(Global.N/2);
    RandPopObj       = eval([Global.Problem '.obj(RandPopDec)']);
    RandPop          = PopStruct(RandPopDec,RandPopObj);
    Global.Evaluated = Global.Evaluated + Global.N/2;
    
    AllPop     = [Population, MemoryPop];
    Population = EnvironmentalSelection(AllPop, Global.N);
    Global.NR  = 1;
    %% Optimization
    while TerminateMN()
        if Global.Evaluated < (Global.NR*Global.T) || Global.Evaluated==0
            [Population, MemoryPop] = MNOptimal(Population, RandPop, MemoryPop);              
        else
            Global.Evaluated = Global.NR*Global.T;
            Global.NR        = Global.NR+1;
            
            RandPopDec       = RandSamp(Global.N/2);
            RandPopObj       = eval([Global.Problem '.obj(RandPopDec)']);
            RandPop          = PopStruct(RandPopDec,RandPopObj);
            Global.Evaluated = Global.Evaluated + Global.N/2;
            
            MemoryPopDec = decs(MemoryPop); 
            MemoryPopObj = eval([Global.Problem '.obj(MemoryPopDec)']);
            MemoryPop    = PopStruct(MemoryPopDec,MemoryPopObj);
            Global.Evaluated = Global.Evaluated + Global.N/2;
            
            PopDec = decs(Population);
            PopObj = eval([Global.Problem '.obj(PopDec)']);
            Population = PopStruct(PopDec, PopObj);
            Global.Evaluated = Global.Evaluated + Global.N;
            
            AllPop     = [Population, MemoryPop];
            Population = EnvironmentalSelection(AllPop, Global.N);
            
            MNData(Population);   
            disp(['---------',num2str(Global.NR),'-------']);
        end
    end
end