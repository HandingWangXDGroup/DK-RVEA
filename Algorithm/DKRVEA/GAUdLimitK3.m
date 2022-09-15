function FinDec = GAUdLimitK3(PopDec, RangeLimit)
    global Global;
    N = Global.N;
    FinDec = [];
    Rnum = 0;
    OldDecs = [];
    while size(FinDec,1) < floor(N)
        if Rnum > 200
            for i = 1:Global.SerNum
                OldData = Global.MultiR(Global.NR-i).TrainData;
                OldDecs = [OldDecs;decs(OldData)];
            end
            Upper = min([max(OldDecs,[],1);RangeLimit(1,:)], [], 1);
            Lower = max([min(OldDecs,[],1);RangeLimit(2,:)], [], 1);
            OffDec = rand([max(floor(N),1),Global.D]).*repmat(Upper-Lower,max(floor(N),1),1)+repmat(Lower,max(floor(N),1),1);
        else
            OffDec = GA(PopDec);
        end
        MaxID  = all(OffDec <= repmat(RangeLimit(1,:),size(OffDec,1),1), 2);
        MinID  = all(OffDec >= repmat(RangeLimit(2,:),size(OffDec,1),1), 2);
        Idx    = MaxID.*MinID;
        OffDec = OffDec(find(Idx == 1),:);
        FinDec = [FinDec;OffDec];
        Rnum = Rnum+1;
    end
end