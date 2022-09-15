function TFlag = TerminateRate()
    global Global;
    if Global.Evaluated<=Global.Evaluation
        TFlag    = 1;
    else
        TFlag    = 0;
        MIGD     = mean(Global.IGD);
        IGD      = Global.IGD;
        filename = ['F:\各种资料\My_alg\EXDMOP\Datatest5\', Global.Algorithm, Global.Problem, '-', num2str(Global.Irun), '.mat'];
        RunNum   = Global.Irun;
        %CMIGD    = mean(Global.IGD(Global.SerNum:end));
        MRate = Global.MRate;
        SRate = Global.SRate;
        save(filename, 'RunNum', 'IGD', 'MIGD', 'MRate', 'SRate');
    end
end