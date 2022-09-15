function ModelPPS(Population)
    global Global;
    PopDec   = decs(Population);
    [N, ~]   = size(PopDec);
    Center   = sum(PopDec,1)/N;
    MainFold = PopDec-Center;
    Global.PopDec.old   = Global.PopDec.new;
    Global.PopDec.new   = PopDec;
    Global.CenterSeries = [Center; Global.CenterSeries];
    Global.CenterSeries = Global.CenterSeries(1:end-1,:);
    Global.MFSeries.old = Global.MFSeries.new;
    Global.MFSeries.new = MainFold;
    
    Temp             = Global.Evaluated;
    Global.Evaluated = floor((Global.NR-0.5)*Global.T); 
    [FrontNo,~]      = NDSort(objs(Population),length(Population));
    Next = FrontNo == 1;
    Population       = Population(Next);
    Global.IGD(Global.NR) = CalIGD(Population);
    Global.OutPop(Global.NR).A1 = Population; 
    Global.Evaluated = Temp;
end