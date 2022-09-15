function KTDMOEA()
    global Global;
    partNum=10;
    Global.Evaluation = 3*Global.N*100;
    T = 1;
    
    while TerminateKT()
        if T==1 || T==2
            init_pop = RandSamp(Global.N)';
            [PopX,Pareto]  =moead(Global.N,init_pop);    
            Global.Evaluated = Global.Evaluated + Global.N*3;
            [~,kneeS]=getKneeGroup(Pareto,partNum);
            LastPopX=PopX;
            LastRank=asignRank(PopX,kneeS);
            kneeArray{T}=kneeS;
            A1Dec = PopX';
            A1Obj = eval([Global.Problem '.obj(A1Dec)']);
            A1 = PopStruct(A1Dec, A1Obj);
            Global.IGD(T) = CalIGD(A1);
            Global.OutPop(T).A1 = A1;
        else
            kneeS=TPM(kneeArray,T);
            PopX = RandSamp(Global.N)';
            Rank=asignRank([PopX kneeS],kneeS);
            PopX=[PopX kneeS];
            testPopX=[generateRandomPoints(PopX) generateRandomPoints(PopX)];
            [predictPopX,~]=predictPopulationKnee(LastPopX',LastRank',PopX',Rank',testPopX',partNum);
            initPopulation=predictPopX;
            if size(initPopulation,2)>Global.N
                initPopulation=initPopulation(:,1:floor(Global.N/1.2));
            elseif size(predictPopX,2)==0
                initPopulation=PopX;
                if size(initPopulation,2)>=floor(Global.N/1.2)
                    initPopulation=initPopulation(:,1:floor(Global.N/1.2));
                else
                    initPopulation=initPopulation(:,end);
                end
            end    
            [PopX,Pareto]  =moead(Global.N, initPopulation); 
            Global.Evaluated = Global.Evaluated + Global.N*3;
            [~,kneeS]      =getKneeGroup(Pareto,partNum);
            LastPopX=PopX;
            LastRank=asignRank(PopX,kneeS); 
            kneeArray{T}=kneeS;
            A1Dec = PopX';
            A1Obj = eval([Global.Problem '.obj(A1Dec)']);
            A1 = PopStruct(A1Dec, A1Obj);
            [FrontNo,~] = NDSort(objs(A1),length(A1));
            Next = FrontNo == 1;
            A1   = A1(Next);
            Global.IGD(T) = CalIGD(A1);
            Global.OutPop(T).A1 = A1;
        end
        T = T+1;
    end
end

function [kneeF,kneeS]=getKneeGroup(Pareto,partNum)
    [boundaryS,boundaryF]=getBoundary(Pareto.X,Pareto.F);
    [posArr,pofArr]=partition(Pareto.X,Pareto.F,partNum,boundaryF);
    for partNo=1:partNum
        [kneeS,kneeF]=getKnees(posArr{partNo},pofArr{partNo});
        kneeSArr{partNo}=kneeS;
        kneeFArr{partNo}=kneeF;
    end
    kneeS=cell2mat(kneeSArr);
    kneeF=cell2mat(kneeFArr);
end


function Rank=asignRank(PopX,KneeX)
    for i=1:size(PopX,2)
        for j=1:size(KneeX,2)
            if isequal(PopX(:,i),KneeX(:,j))==1
                Rank(i)=1;
                break;
            else
                Rank(i)=-1;
            end
        end
    end
end

