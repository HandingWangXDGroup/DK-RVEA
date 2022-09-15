function TFlag = Terminate()
    global Global;
    if Global.Evaluated<=Global.Evaluation
        TFlag    = 1;
    else
        ModelPara= Global.MultiR;
        TFlag    = 0;
        MIGD     = mean(Global.IGD);
        IGD      = Global.IGD;
        filename = Global.filename;
        RunNum   = Global.Irun;
        %IniIGD   = Global.IniIGD;
        %AnaData  = Global.AnaData;
        %IGDData = Global.IGDData;
        save(filename, 'RunNum', 'IGD', 'MIGD', 'ModelPara');
    end
end