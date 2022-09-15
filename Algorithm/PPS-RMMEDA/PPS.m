function Population = PPS()
    global Global;
    %% 
    if Global.NR <= Global.SerNum
        OldPop     = Global.PopDec.old;
        NewPop     = Global.PopDec.new;
        [N, ~]     = size(OldPop);
        RandIndex  = randperm(N)';
        PopDec     = [OldPop(RandIndex(1:floor(N/2)),:); NewPop(RandIndex(floor(N/2)+1:end),:)];
        PopObj     = eval([Global.Problem '.obj(PopDec)']);
        Global.Evaluated = Global.Evaluated + size(PopObj,1);
        Population = PopStruct(PopDec, PopObj);
    else
        %% Predict the Mainfold
        Dis    = sum(min(pdist2(Global.MFSeries.old,Global.MFSeries.new),[],2)) /Global.N;
        Theta  = Dis^2/Global.D;
        MFRand = normrnd(0, Theta, [Global.N,Global.D]);
        NewMF  = Global.MFSeries.new+MFRand;
        %% Predict the Centers
        Lambda = zeros(Global.P, Global.D);
        Theta  = zeros(1, Global.D);
        for j=1:Global.D
            Fi      = zeros(Global.SerNum-Global.P, Global.P);
            CenterJ = Global.CenterSeries(:,j);
            Psi     = CenterJ(1:Global.SerNum-Global.P);
            for Id  = 2:Global.SerNum-Global.P+1
                Fi(Id-1,:) = CenterJ(Id:Id+Global.P-1);
            end
            Lambda(:,j) = inv(Fi'*Fi)*Fi'*Psi;
            Theta(j)    = sum((Psi-Fi*Lambda(:,j)).^2)/(Global.SerNum-Global.P);  
        end
        NewCenter = diag(Global.CenterSeries(1:Global.P,:)'*Lambda)'+normrnd(0,Theta);
    
           %% Generate New Population
            PopDec     = NewMF+repmat(NewCenter, Global.N, 1);
            LowerDec   = 0.5*(repmat(Global.Lower,Global.N,1)+Global.PopDec.new);
            UpperDec   = 0.5*(repmat(Global.Upper,Global.N,1)+Global.PopDec.new);
            LowIndex   = find(PopDec<repmat(Global.Lower,Global.N,1));
            UppIndex   = find(PopDec>repmat(Global.Upper,Global.N,1));
            PopDec(LowIndex) = LowerDec(LowIndex);
            PopDec(UppIndex) = UpperDec(UppIndex);
            PopObj     = eval([Global.Problem '.obj(PopDec)']);
            Global.Evaluated = Global.Evaluated + size(PopObj,1);
            Population = PopStruct(PopDec, PopObj);
    end
end