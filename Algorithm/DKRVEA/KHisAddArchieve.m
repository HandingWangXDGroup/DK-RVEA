function A1 = KHisAddArchieve(A1, TransFlag)
    %%
    global Global
    AddNum   = 20;     
    if length(TransFlag)==1 && all(TransFlag)
        if ~isempty(fieldnames(Global.HisTrain))
            HisDec = decs(Global.HisTrain); HisObj = objs(Global.HisTrain);
            AddNum = min(AddNum, length(Global.HisTrain));
            RandID = randperm(length(Global.HisTrain)); idx = RandID(1:AddNum);
            LeftDec= HisDec(idx,:); LeftObj = HisObj(idx,:);
            HisDec(idx,:)=[]; HisObj(idx,:)=[];  A1Dec = decs(A1); 
            [~, idx]         = ismember(A1Dec, LeftDec, 'rows');
            idx(find(idx==0))= [];
            LeftDec(idx,:)   = []; LeftObj(idx,:) = [];
            LeftPop          = PopStruct(LeftDec, LeftObj);
            if ~isempty(fieldnames(LeftPop))
                A1 = [A1, LeftPop];    
            end         
            Global.HisTrain  = PopStruct(HisDec,HisObj);  
        end
    else
        AddObj = find(TransFlag==1);
        for j= AddObj
            if  ~isempty(fieldnames(Global.HisTrain{j}))
                HisDec = decs(Global.HisTrain{j});
                HisObj = objs(Global.HisTrain{j});
                AddNum = min(AddNum,size(HisDec,1));
                AddID  = randperm(AddNum);
                AddPop = PopStruct(HisDec(AddID,:), HisObj(AddID,:));
                if isfield(Global,'AddData')
                    Global.AddData{j} = [Global.AddData{j},AddPop];              
                else
                    for i = AddObj
                        Global.AddData{i} = AddPop;
                    end
                end
                HisDec(AddID,:) = []; HisObj(AddID,:) = [];
                Global.HisTrain{j} = PopStruct(HisDec,HisObj);
                AddNum = 20;
            end
        end
    end
end