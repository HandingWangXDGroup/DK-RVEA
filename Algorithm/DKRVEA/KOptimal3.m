function [Population, Model, A1, THETA,V,Rate] = KOptimal3(Model, PopDec, V, V0, alpha, wmax, mu, NI, THETA, A1, TransFlag,Gen,Rate)  
    global Global;
    w        = 1;
    A1Obj    = objs(A1);
    PopDec   = decs(A1);
    %% Optimization
    while w <= wmax   
        OffDec = GA(PopDec);
        PopDec = [PopDec;OffDec];
        [N,~]  = size(PopDec);
        PopObj = zeros(N,Global.M);
        MSE    = zeros(N,Global.M);
        for i = 1: N
            for j = 1 : Global.M
                [PopObj(i,j),~,MSE(i,j)] = predictor(PopDec(i,:),Model{j});
            end
        end  
        index  = KEnvironmentalSelection(PopObj,V,(w/wmax)^alpha);
        PopDec = PopDec(index,:);
        PopObj = PopObj(index,:);
        % Adapt referece vectors
        if ~mod(w,ceil(wmax*0.1))
            V(1:Global.N,:) = V0.*repmat(max(PopObj,[],1)-min(PopObj,[],1),size(V0,1),1);
        end
        w = w + 1; 
    end
    [NumVf,~]    = NoActive(A1Obj,V0);
    
    if Global.NR > Global.SerNum && Rate<=0
        [TransDec,TransObj,TransMSE,NewCenter] = PPSK3(PopDec,Model);
        if Gen == 1
            Global.MultiR(Global.NR).PPS = TransDec;
        end
        CenterObj     = eval([Global.Problem '.obj(NewCenter)']);
        [TransNew,idx] = KrigingSelectRF(TransDec,TransObj,TransMSE,V,V0,NumVf,0.05*Global.N,mu,(w/wmax)^alpha); 
        TransNewSObj   = TransObj(idx,:); TransNewSMSE = TransMSE(idx,:);
        
        [PopNew,idx]   = KrigingSelectRF(PopDec,PopObj,MSE,V,V0,NumVf,0.05*Global.N,mu,(w/wmax)^alpha); 
        PopSObj = PopObj(idx,:); PopSMSE = MSE(idx,:);
        SNew = [TransNew;PopNew]; SObj = [TransNewSObj;PopSObj]; SMSE = [TransNewSMSE;PopSMSE];
        
        [PopNew,~] = KrigingSelectRF(SNew,SObj,SMSE,V,V0,NumVf,0.05*Global.N,mu,(w/wmax)^alpha);
        PopObj = [TransObj;PopObj]; PopDec = [TransDec;PopDec]; MSE = [TransMSE;MSE];
        index  = KEnvironmentalSelection(PopObj,V,(w/wmax)^alpha);
        
        PopDec = PopDec(index,:); PopObj = PopObj(index,:);
        CalRateFlag = 1;
    else
        CalRateFlag = 0;
        [NumVf,~]  = NoActive(A1Obj,V0);
        [PopNew,~] = KrigingSelectRF(PopDec,PopObj,MSE,V,V0,NumVf,0.05*Global.N,mu,(w/wmax)^alpha);        
    end 
    
    Population= PopStruct(PopDec, PopObj);   
    NewObj    = eval([Global.Problem '.obj(PopNew)']);
    if Global.NR > Global.SerNum && CalRateFlag
        NewDis = NewObj-repmat(CenterObj,size(NewObj,1),1);
        Rate   = sum(all(NewDis<0,2))/size(NewObj,1);
    end
    New = PopStruct(PopNew, NewObj);
    Global.Evaluated = Global.Evaluated+length(New);
    if Global.NR>Global.Rs
        A1 = KHisAddArchieve(A1, TransFlag);
    end
    A1 = KHisUpdataArchive(A1,New,V,mu,NI, TransFlag);  
    if Global.Evaluated >= Global.NR * Global.T
        Global.MultiR(Global.NR).OptimalPop = Population;
    end
    %% ReTrain
    for j = 1 : Global.M
        if length(TransFlag)>1 && TransFlag(j)==1
            AddPop = Global.AddData{j}; A1Dec = decs(A1);
            A1Obj  = eval([Global.Problem '.obj(A1Dec)']);
            AddObj = objs(AddPop) ;
            Dec    = [decs(A1);decs(AddPop)];
            Obj    = [A1Obj(:,j);AddObj(:,j)];
        else
            Dec    = decs(A1);
            Obj    = eval([Global.Problem '.obj(Dec)']);
            Obj    = Obj(:,j);            
        end
        ReID = [];
        Dis  = pdist2(Dec,Dec);
        for i=1:size(Dis,1)-1
            for k=i+1:size(Dis,2)
                if ~ismember(i,ReID)
                    if Dis(i,k) < 10^-5
                        ReID = [ReID,k];
                    end
                end
            end
        end
        Dec(ReID,:) = []; Obj(ReID) = [];
        dmodel     = dacefit(Dec,Obj,'regpoly1','corrgauss',THETA(j,:),1e-5.*ones(1,Global.D),100.*ones(1,Global.D));
        Model{j}   = dmodel;
        THETA(j,:) = dmodel.theta;
    end
    
    
end