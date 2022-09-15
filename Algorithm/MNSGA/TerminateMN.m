function TFlag = TerminateMN()
    global Global;
    if Global.Evaluated<=Global.Evaluation
        TFlag    = 1;
    else
        OutPop   = Global.OutPop;
        TFlag    = 0;
        MIGD     = mean(Global.IGD);
        IGD      = Global.IGD;
        filename = ['D:\Myworks\EXDMOPs\Data\9\', Global.Algorithm, Global.Problem, '-', num2str(Global.Irun), '.mat'];
        RunNum   = Global.Irun;
        %IniIGD   = Global.IniIGD;
        %AnaData  = Global.AnaData;
        %IGDData = Global.IGDData;
        save(filename, 'RunNum', 'IGD', 'MIGD', 'OutPop');
    end
end