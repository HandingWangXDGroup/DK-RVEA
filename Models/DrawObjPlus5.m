function DrawObjPlus5(A1Dec, LocateFlag, CurGen, SingleFlag, PopDec)
    global Global;
    mu = 5;
    A1Obj  = eval([Global.Problem '.obj(A1Dec)']);    %% Non-dominated sorting
    PopObj = eval([Global.Problem '.obj(PopDec)']);
    Population = PopStruct(PopDec, PopObj);
    %%
    N = min(size(A1Dec,1),100);
    [FrontNo,MaxFNo] = NDSort(A1Obj,N);
    Next = FrontNo < MaxFNo;
    CrowdDis = CrowdingDistance(A1Obj,FrontNo);
    Last     = find(FrontNo==MaxFNo);
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:N-sum(Next)))) = true;
    A1Dec = A1Dec(Next,:); A1Obj = A1Obj(Next,:);
    %%
    subplot(2,2,LocateFlag*2-1);
    if size(A1Obj,2)==2
        scatter(A1Obj(:,1), A1Obj(:,2));
    else
        scatter3(A1Obj(:,1), A1Obj(:,2), A1Obj(:,3));
    end
    A1 = PopStruct(A1Dec, A1Obj);
    TempE = Global.Evaluated;
    Global.Evaluated = Global.NR*Global.T-1;
    switch LocateFlag
        case 1
            subplot(2,2,LocateFlag*2)      
            Gen = linspace(1,max([(Global.T-Global.D*2)/mu,CurGen,size(Global.OriPopIGD(Global.NR,:),2)]),...
                                    max([(Global.T-Global.D*2)/mu,CurGen,size(Global.OriPopIGD(Global.NR,:),2)]));  
            Global.OriPopIGD(Global.NR, CurGen) = CalIGD(A1);
            Global.MidPopIGD(CurGen) = CalIGD(Population);
            txt = ['\leftarrow ', num2str(Global.OriPopIGD(Global.NR, CurGen))];
            plot(Gen, Global.OriPopIGD(Global.NR,:));
            text(CurGen, Global.OriPopIGD(Global.NR, CurGen)+1, txt);
            hold on;
            Gen = linspace(1,max([(Global.T-Global.D*2)/mu,CurGen,length(Global.MidPopIGD)]),...
                                    max([(Global.T-Global.D*2)/mu,CurGen,length(Global.MidPopIGD)]));  
            plot(Gen, Global.MidPopIGD);
            hold off;
        case 2
            subplot(2,2,LocateFlag*2)
            Gen = linspace(1,max([(Global.T-Global.D*2)/mu,CurGen,size(Global.DSEPopIGD(Global.NR,:),2)]),...
                        max([(Global.T-Global.D*2)/mu,CurGen,size(Global.DSEPopIGD(Global.NR,:),2)]));   
            Global.DSEPopIGD(Global.NR, CurGen) = CalIGD(A1);
            plot(Gen, Global.DSEPopIGD(Global.NR,:));
            txt = ['\leftarrow ', num2str(Global.DSEPopIGD(Global.NR, CurGen))];
            text(CurGen, Global.DSEPopIGD(Global.NR, CurGen)+1, txt);
            if SingleFlag
                title('UseSingle Kri');
            end
    end
    Global.Evaluated = TempE;
end