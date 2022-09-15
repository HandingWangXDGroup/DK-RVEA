function PPS_RMMEDA()
   %% Parameter Setting
    global Global;
    PopDec = RandSamp(Global.N);
    PopObj     = eval([Global.Problem '.obj(PopDec)']);
    Global.Evaluated = Global.Evaluated + size(PopObj,1);
    Population =PopStruct(PopDec, PopObj);
    Global.SerNum = 23;
    Global.P      = 3;
    Global.CenterSeries = zeros(Global.SerNum, Global.D);
    Global.MFSeries.old = zeros(Global.N, Global.D);
    Global.MFSeries.new = Global.MFSeries.old; 
    Global.PopDec.old   = decs(Population);
    Global.PopDec.new   = Global.PopDec.old;
    Global.NR = 1;
    %% Algorithm begin
    while TerminatePPS()
        if Global.Evaluated < (Global.NR*Global.T) || Global.Evaluated==0
            Offspring  = Operator(Population);
            Population = EnvironmentalSelection([Population,Offspring],Global.N);
        else
            ModelPPS(Population);
            Population = PPS();
            Global.NR = Global.NR+1;
        end
    end
    
end