function TFlag = TerminateKT()
    global Global;
    if Global.Evaluated<=Global.Evaluation
        TFlag    = 1;
    else
        OutPop   = Global.OutPop;
        TFlag    = 0;
        MIGD     = mean(Global.IGD);
        IGD      = Global.IGD;
        filename = ['E:\job3\Data\FinalKData9\', Global.Algorithm, Global.Problem, '-', num2str(Global.Irun), '.mat'];
        RunNum   = Global.Irun;
        save(filename, 'RunNum', 'IGD', 'MIGD', 'OutPop');
    end
end