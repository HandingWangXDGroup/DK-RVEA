function ModelData(A1, Model)
    global Global; 
    Global.MultiR(Global.NR).R = Model;
    Global.MultiR(Global.NR).TrainData= A1;
    Temp             = Global.Evaluated;
    Global.Evaluated = floor((Global.NR-0.5)*Global.T); 
    %%
    [FrontNo,~] = NDSort(objs(A1),length(A1));    
    Next = FrontNo == 1;
    A1   = A1(Next);
    Global.IGD(Global.NR) = CalIGD(A1);
    Global.MultiR(Global.NR).A1 = A1; 
    Global.Evaluated = Temp;
    if length(Global.Problem) == 4 && all(Global.Problem == 'SDP1')
        eval([Global.Problem '.ChangeDec']);
    end
end