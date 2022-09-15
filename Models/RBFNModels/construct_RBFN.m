function Rnets = construct_RBFN(PopDec,PopObj)
    %global Global;
    %%
    [N, ~]     = size(PopObj);  
    center_num = ceil(sqrt(N));   
    %%%����RBFNs&center poings
    KName = 'the_gaussian';
    %%
    Rnets.centers= get_center(PopDec, center_num);          %�õ����ĵ�
    Rnets.sigma  = mean(pdist(Rnets.centers))/2;
    Z = get_Z(PopDec, KName, Rnets);                        %����Ȩ��
    Rnets.name   = KName;
    Rnets.weight = inv(Z'*Z)*Z'*PopObj;
    
end