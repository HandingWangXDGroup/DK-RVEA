function index = KEnvironmentalSelectionSave(PopObj,V,theta)
    [N,M] = size(PopObj);
    NV    = size(V,1);
    %% Translate the population
    PopObj = PopObj - repmat(min(PopObj,[],1),N,1);
    
    %% Calculate the smallest angle value between each vector and others
    cosine = 1 - pdist2(V,V,'cosine');
    cosine(logical(eye(length(cosine)))) = 0;
    gamma = min(acos(cosine),[],2);

    %% Associate each solution to a reference vector
    Angle = acos(1-pdist2(PopObj,V,'cosine'));
    [~,associate] = min(Angle,[],2);
    
    %% Select one solution for each reference vector
    Next = zeros(1,NV);
    for i = unique(associate)'
        current = find(associate==i);
        % Calculate the APD value of each solution
        APD = (1+M*theta*Angle(current,i)/gamma(i)).*sqrt(sum(PopObj(current,:).^2,2));
        % Select the one with the minimum APD value
        [~,best] = min(APD);
        Next(i)  = current(best);
    end
    % Population for next generation
    index = Next(Next~=0);
    PopObj(index,:)=[]; Objidx=1:N; Objidx(index)=[];
    Angle = acos(1-pdist2(PopObj,V,'cosine'));
    Unssignidx = find(Next==0);
    if ~isempty(PopObj)
        for i=Unssignidx
            APD      = M*Angle(:,i)/gamma(i);
            [~,best] = min(APD);
            Next(i)  = Objidx(best);
            PopObj(best,:)=[]; Objidx(best)=[];
            if isempty(PopObj)
                break;
            end
            Angle    = acos(1-pdist2(PopObj,V,'cosine'));
        end
        index = Next(Next~=0);
    end
end