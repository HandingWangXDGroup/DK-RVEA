function Population = InitialPop()
    %% Initialization the Popualtion
    global Global;
    PopDec= rand(Global.N,Global.D).* (repmat(Global.Upper,Global.N,1) ... 
                    -repmat(Global.Lower,Global.N,1))+repmat(Global.Lower,Global.N,1);
    PopObj     = eval([Global.Problem '.obj(PopDec)']);
    Population = PopStruct(PopDec, PopObj);
end