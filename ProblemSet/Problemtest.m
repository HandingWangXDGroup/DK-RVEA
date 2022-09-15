function PopObj = Problemtest()
    global Global
    Global.Problem = 'SDP3'; Global.nt = 20;
    Global.NR = 1; Global.D = 30; Global.M = 3; Global.Evaluated = 100; Global.T = 100; Global.Nr = 2000;
%     y_t = repmat(linspace(1,Global.D,Global.D),100,1)/Global.D;
%     Global.y(Global.NR).yy = y_t;
    for NR = 1:10
        Global.NR = NR;
        Global.Evaluated = Global.NR*Global.T;
        PopDec   = rand([100,Global.D]);
        PopObj   = eval([Global.Problem '.obj(PopDec)']);
        [PF, ~]  = eval([Global.Problem '.RefPoints()']);
        %eval([Global.Problem '.ChangeDec']);
        figure();
        scatter3(PF(:,1),PF(:,2),PF(:,3));
    end
end