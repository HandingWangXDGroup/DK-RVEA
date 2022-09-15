function MNData(Population)
    global Global;
    Temp             = Global.Evaluated;
    Global.Evaluated = floor((Global.NR-0.5)*Global.T); 
    [FrontNo,~]      = NDSort(objs(Population),length(Population));
    Next = FrontNo == 1;
    Population       = Population(Next);
    Global.IGD(Global.NR)       = CalIGD(Population);
    Global.OutPop(Global.NR).A1 = Population; 
    Global.Evaluated = Temp;
end