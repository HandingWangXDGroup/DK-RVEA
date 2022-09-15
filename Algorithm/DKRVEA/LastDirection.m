function [TransDec,TransObj,TransMSE] = LastDirection(PopDec,Model,Gen)
    global Global;
    %% Predict the LastDir
    CurCenter = mean(PopDec,1);
    Qt = PopDec-repmat(CurCenter, size(PopDec,1), 1);
    LastPop = Global.MultiR(Global.NR-1).SearchPop(Gen).Pop;
    LastA1  = Global.MultiR(Global.NR-1).A1;
    [FrontNo,MaxFNo] = NDSort(objs(LastA1),Global.D);
    Next             = FrontNo < MaxFNo;
    CrowdDis         = CrowdingDistance(objs(LastA1),FrontNo);
    Last             = find(FrontNo==MaxFNo);
    [~,Rank]         = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:Global.D-sum(Next)))) = true;
    LastA1 = LastA1(Next);
    LastA1Dec = decs(LastA1); LastPopDec = decs(LastPop); 
    LastDir = mean(LastA1Dec)-mean(LastPopDec);
    NewCenter = CurCenter + LastDir;
   %% Generate New Population
    N = size(PopDec,1);
    TransDec   = Qt+repmat(NewCenter, N, 1);
    LowerDec   = 0.5*(repmat(Global.Lower,N,1)+PopDec);
    UpperDec   = 0.5*(repmat(Global.Upper,N,1)+PopDec);
    LowIndex   = find(TransDec<repmat(Global.Lower,N,1));
    UppIndex   = find(TransDec>repmat(Global.Upper,N,1));
    TransDec(LowIndex) = LowerDec(LowIndex);
    TransDec(UppIndex) = UpperDec(UppIndex);
    %% Model Evaluation
    TransObj = zeros(N,Global.M);
    TransMSE = zeros(N,Global.M);
    for i = 1: N
        for j = 1 : Global.M
            [TransObj(i,j),~,TransMSE(i,j)] = predictor(TransDec(i,:),Model{j});
        end
    end 
end