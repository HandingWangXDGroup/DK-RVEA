function IniPopulation = PreAE(AllNDs, Population)
    global Global

    CurND = AllNDs(Global.NR).NDs;
    LastND= AllNDs(Global.NR-1).NDs;
    MinL  = min(length(CurND),length(LastND));
    [MCurND,~,~] = EnvironmentalSelection(CurND,MinL);
    [MLastND,~,~]= EnvironmentalSelection(CurND,MinL);
    IniDec= AE_prediction(decs(MCurND)', decs(MLastND)', decs(CurND)', Global.N);
    IniDec= IniDec';

    CurL  = size(IniDec,1);
    LeftL = Global.N-CurL;
    [LeftPop,~,~] = EnvironmentalSelection(Population,LeftL);
    IniDec = [IniDec;decs(LeftPop)];
    IniObj = eval([Global.Problem '.obj(IniDec)']);
    Global.Evaluated = Global.Evaluated + size(IniDec,1);
    IniPopulation = PopStruct(IniDec,IniObj);
end