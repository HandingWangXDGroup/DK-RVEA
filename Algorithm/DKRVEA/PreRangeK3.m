function RangeLimit = PreRangeK3()
    %% Select the Optimal solutions
    global Global
    N = Global.D;
    Temp    = Global.Evaluated;
    %MeanSer = zeros([Global.D, Global.SerNum]);
    culNum  = 1;
    for i=Global.NR-Global.SerNum:Global.NR-1
        A1 = Global.MultiR(i).TrainData;
        [V,~]  = UniformPoint(N,Global.M);
        index  = InverseAPDK3(objs(A1),V,1);
        A1     = A1(index);  
        A1Dec  = decs(A1);
        MinSer(:,culNum) = min(A1Dec,[],1)';
        MaxSer(:,culNum) = max(A1Dec,[],1)';
        culNum = culNum+1;
    end
    %% Predict the optimal range in the next time
    RangeLimit = [inf(1,Global.D);-inf(1,Global.D)];
    Pnum = zeros([Global.D,2]);
    for i=1:Global.D
        % Select the Pnum of the lower poly
        for P = 2:10
            JudgeP = zeros([5,1]);
            for j = Global.SerNum-3:Global.SerNum
                XX = j-(Global.SerNum-4):1:j-1;
                p1 = polyfit(XX, MaxSer(i,j-(Global.SerNum-4):j-1), P);
                PMax = polyval(p1, j);
                if (PMax-MaxSer(i,j-1))*(MaxSer(i,j)-MaxSer(i,j-1)) > 0
                    JudgeP(Global.SerNum-j+1) = 1;
                end
            end
            if sum(JudgeP) > 3
                Pnum(i,1) = P;
                break
            end
        end

        for P = 2:10
            JudgeP = zeros([5,1]);
            for j = Global.SerNum-3:Global.SerNum
                XX = j-(Global.SerNum-4):1:j-1;
                p2 = polyfit(XX, MinSer(i,j-(Global.SerNum-4):j-1), P);
                PMin = polyval(p2, j);
                if (PMin-MinSer(i,j-1))*(MinSer(i,j)-MinSer(i,j-1)) > 0
                    JudgeP(Global.SerNum-j+1) = 1;
                end
            end
            if sum(JudgeP) > 3
                Pnum(i,2) = P;
                break
            end
        end

        %%% Prediction
        XX = Global.NR-Global.SerNum:1:Global.NR-1;
        pchmax(i) = pchip(XX, MaxSer(i,:), Global.NR);
        pchmin(i) = pchip(XX, MinSer(i,:), Global.NR);
        if Pnum(i,1) > 0
            p1 = polyfit(XX, MaxSer(i,:), Pnum(i,1));
            PreMax(i) = polyval(p1, Global.NR);
            if PreMax(i) < MaxSer(i,end)
                RangeLimit(1,i) = MaxSer(i,end);
            end
        end
        
        if Pnum(i,2) > 0 
            p2 = polyfit(XX, MinSer(i,:), Pnum(i,2));
            PreMin(i) = polyval(p2, Global.NR);
            if PreMin(i) > MinSer(i,end)
                RangeLimit(2,i) = MinSer(i,end);
            end
        end
    end
    Global.Evaluated = Temp;
end