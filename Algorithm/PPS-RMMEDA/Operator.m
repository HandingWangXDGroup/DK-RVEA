function Offspring = Operator(Population, K)
    %% Parameter setting
    global Global;
    if nargin < 2
        K = 5;
    end
    PopDec = decs(Population);
    [N,D]  = size(PopDec);
    M      = length(Population(1).obj);
    
    %% Modeling
    [Model,probability] = LocalPCA(PopDec,M,K);

    %% Reproduction
    OffDec = zeros(N,D);
    % Generate new trial solutions one by one
    for i = 1 : N
        % Select one cluster by Roulette-wheel selection
        k = find(rand<=probability,1);
        % Generate one offspring
        if ~isempty(Model(k).eVector)
            lower = Model(k).a - 0.25*(Model(k).b-Model(k).a);
            upper = Model(k).b + 0.25*(Model(k).b-Model(k).a);
            trial = rand(1,M-1).*(upper-lower) + lower;
            sigma = sum(abs(Model(k).eValue(M:D)))/(D-M+1);
            OffDec(i,:) = Model(k).mean + trial*Model(k).eVector(:,1:M-1)' + randn(1,D)*sqrt(sigma);
        else
            OffDec(i,:) = Model(k).mean + randn(1,D);
        end
    end
    OffDec    = max(min(OffDec,repmat(Global.Upper,N,1)), repmat(Global.Lower,N,1));
    OffObj    = eval([Global.Problem '.obj(OffDec)']);
    Global.Evaluated = Global.Evaluated + size(OffDec,1);
    Offspring = PopStruct(OffDec, OffObj);
end