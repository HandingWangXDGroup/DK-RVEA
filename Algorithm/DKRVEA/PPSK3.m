function [TransDec,TransObj,TransMSE,FixNewCenter] = PPSK3(PopDec,Model)
    global Global;
    Mnum = Global.SerNum;
    Pnum = 3;
    CenterPoints = zeros([Mnum,Global.D]);
    for i = 1:Mnum
        A1 = Global.MultiR(Global.NR-i).TrainData;
        [FrontNo,MaxFNo] = NDSort(objs(A1),Global.D);
        Next = FrontNo == 1;
        A1 = A1(Next);
        A1Dec = decs(A1);
        CenterPoints(i,:) = mean(A1Dec,1);
    end
    LastPop = Global.MultiR(Global.NR-1).OptimalPop;
    Qt = decs(LastPop)-mean(decs(LastPop),1);
    N = length(LastPop);
    %% Predict the Centers
    Lambda = zeros(Pnum, Global.D);
    Theta  = zeros(1, Global.D);
    for j=1:Global.D
        Fi      = zeros(Mnum-Pnum+1, Pnum);
        Psi     = CenterPoints(1:Mnum-Pnum+1,j);
        for Id  = 1:Mnum-Pnum+1
            Fi(Id,:) = CenterPoints(Id:Id+Pnum-1,j)';
        end
        Lambda(:,j) = inv(Fi'*Fi)*Fi'*Psi;
        Theta(j)    = sum((Psi-Fi*Lambda(:,j)).^2)/(Mnum-Pnum);  
    end
    FixNewCenter = diag(CenterPoints(1:Pnum,:)'*Lambda)';
    NewCenter  = diag(CenterPoints(1:Pnum,:)'*Lambda)'+Theta; 
    
   %% Generate New Population
    OldOldPop  = Global.MultiR(Global.NR-2).OptimalPop;
    OldQt      = decs(OldOldPop)-mean(decs(OldOldPop),1);
    Dis = sum(min(pdist2(Qt,OldQt),[],2))/Global.N;
    Theta      = Dis.^2/Global.D;
    QRand      = normrnd(0,Theta,[size(Qt,1),Global.D]);
    Qt  = Qt+QRand;
    TransDec   = Qt+repmat(NewCenter, N, 1);
    LowerDec   = 0.5*(repmat(Global.Lower,N,1)+decs(LastPop));
    UpperDec   = 0.5*(repmat(Global.Upper,N,1)+decs(LastPop));
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