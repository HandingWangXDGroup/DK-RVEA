function [A1, Model, TransFlag] = KHisInitial(THETA, V)
    global Global;
    %% Initialize the New Model in t+1
    Global.Evaluated = Global.Evaluated+size(Global.ObsDec,1);
    ObsObj = eval([Global.Problem '.obj(Global.ObsDec)']);
    A1     = PopStruct(Global.ObsDec,ObsObj);
    Global.MultiR(Global.NR).ObsObj = ObsObj;
    

    for i = 1 : Global.M
        dmodel     = dacefit(Global.ObsDec,ObsObj(:,i),'regpoly1','corrgauss',THETA(i,:),1e-5.*ones(1,Global.D),100.*ones(1,Global.D));
        Model{i}   = dmodel;
        THETA(i,:) = dmodel.theta;
    end
    TransFlag = zeros([1,Global.M]);
    %%
    if Global.NR> Global.Rs
        HisNum = KHisCalSim1(ObsObj);  
        if length(HisNum)==1
            TransFlag = 1;
            Global.HisTrain = Global.MultiR(HisNum).TrainData;
            HisDec  = decs(Global.HisTrain);
            HisObj  = objs(Global.HisTrain);
            [~,idx] = ismember(HisDec, Global.ObsDec, 'rows');
            idx     = idx(idx>0);
            HisDec(idx,:)   = []; HisObj(idx,:) = [];         
            Global.HisTrain = PopStruct(HisDec,HisObj);
        else
            TransFlag = zeros([1,Global.M]);
            for j=1:Global.M
                Global.HisTrain{j} = Global.MultiR(HisNum(j)).TrainData;
                HisObsObj          = Global.MultiR(HisNum(j)).ObsObj;
                if max(abs(HisObsObj(:,j)-ObsObj(:,j)))<=10^-3
                    TransFlag(j) = 1;
                end        
                HisDec  = decs(Global.HisTrain{j});
                HisObj  = objs(Global.HisTrain{j});
                [~,idx] = ismember(HisDec, Global.ObsDec, 'rows');
                idx     = idx(idx>0);
                HisDec(idx,:) = []; HisObj(idx,:) = [];
                Global.HisTrain{j} = PopStruct(HisDec,HisObj);
            end
        end    
        A1 = KHisAddArchieve(A1, TransFlag);
    end
end