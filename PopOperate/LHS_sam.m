function IniPop = LHS_sam(SamN)
%%%���ݾ��߷�Χ���������ʼ��Ⱥ,var_boundsΪ���߱�����Χ
%%%ʹ������������������
    global Global;
    %%
    IniDec = zeros(SamN, Global.D);
    for j=1:Global.D
        linepart = linspace(Global.Lower(j), Global.Upper(j), SamN+1)';
        randval  = rand(SamN,1)*(linepart(2)-linepart(1));
        IniDec(:,j) = linepart(1:end-1)+randval;
    end
    %���Ҹ�ά��˳��
    for j=1:Global.D
        RandID = randperm(size(IniDec, 1));
        IniDec(:, j) = IniDec(RandID, j);
    end
    %%
    IniObj = eval([Global.Problem '.obj(IniDec)']);
    Global.Evaluated = Global.Evaluated+SamN;
    IniPop = PopStruct(IniDec, IniObj);
end