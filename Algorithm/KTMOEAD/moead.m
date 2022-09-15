function [PopX,Pareto]=moead(popSize,init_pop)
    global Global;

    VarSize=[Global.D 1];   % Decision Variables Matrix Size

    VarMin = Global.Lower;         % Decision Variables Lower Bound
    VarMax = Global.Upper;         % Decision Variables Upper Bound
    MaxIt  = 2;

    %% MOEA/D Settings


    nPop=popSize;    % Population Size (Number of Sub-Problems)

    nArchive=50;

    T=max(ceil(0.15*nPop),2);    % Number of Neighbors
    T=min(max(T,2),15);

    crossover_params.gamma=0.5;
    crossover_params.VarMin=VarMin;
    crossover_params.VarMax=VarMax;

    %% Initialization

    % Create Sub-problems
    sp=CreateSubProblems(Global.M,nPop,T);

    % Empty Individual
    empty_individual.Position=[];
    empty_individual.Cost=[];
    empty_individual.g=[];
    empty_individual.IsDominated=[];

    % Initialize Goal Point
    %z=inf(Global.M,1);
    z=zeros(Global.M,1);

    % Create Initial Population
    pop=repmat(empty_individual,nPop,1);
    if size(init_pop,2) < nPop
        Addpop   = RandSamp(nPop-size(init_pop,2))';
        init_pop = [init_pop,Addpop];
    end

    for i=1:size(init_pop,2)
        pop(i).Position=init_pop(:,i);
        Dec = pop(i).Position';
        pop(i).Cost=eval([Global.Problem '.obj(Dec)'])';
        z=min(z,pop(i).Cost);
    end

    for i=1:nPop
        pop(i).g=DecomposedCost(pop(i),z,sp(i).lambda);
    end

    % Determine Population Domination Status
    pop=DetermineDomination(pop);

    % Initialize Estimated Pareto Front
    EP=pop(~[pop.IsDominated]);

    %% Main Loop

    for it=1:MaxIt
        for i=1:nPop

            % Reproduction (Crossover)
            K=randsample(T,2);

            j1=sp(i).Neighbors(K(1));
            p1=pop(j1);

            j2=sp(i).Neighbors(K(2));
            p2=pop(j2);

            y=empty_individual;
            y.Position=M_Crossover(p1.Position,p2.Position,crossover_params);
            Decy  = y.Position';
            y.Cost= eval([Global.Problem '.obj(Decy)'])';
            z=min(z,y.Cost);

            for j=sp(i).Neighbors
                y.g=DecomposedCost(y,z,sp(j).lambda);
                if y.g<=pop(j).g
                    pop(j)=y;
                end
            end 
        end

        % Determine Population Domination Status
        pop=DetermineDomination(pop);

        ndpop=pop(~[pop.IsDominated]);

        EP=[EP
            ndpop]; %#ok

        EP=DetermineDomination(EP);
        EP=EP(~[EP.IsDominated]);

        if numel(EP)>nArchive
            Extra=numel(EP)-nArchive;
            ToBeDeleted=randsample(numel(EP),Extra);
            EP(ToBeDeleted)=[];
        end

        for arcnum=1: size(EP,1)
            pareto(:,arcnum)=EP(arcnum).Cost;
        end
    end
    Pareto.F=[EP.Cost];
    Pareto.X=[EP.Position];
    PopX=Pareto.X;
end
