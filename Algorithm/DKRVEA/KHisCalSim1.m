function HisNum = KHisCalSim1(ObsObj)
    global Global;
    %% Caculate the b of Distance
    SerNum    = Global.NR-1;
    MarSerCal = zeros(size(ObsObj,1), Global.M, SerNum);   
    for i= 1:SerNum
        MarSerCal(:,:,i)= (Global.MultiR(i).ObsObj-ObsObj).^2;
    end
    %%
    MarSerCal = sqrt(squeeze(mean(MarSerCal,1)));
    RolNum = find((max(MarSerCal,[],1)<=10^-3) == 1);
    if ~isempty(RolNum)
        HisNum = RolNum(1);
    else
        HisNum = zeros([1,Global.M]);
        for j=1:Global.M
            [~,HisNum(j)] = min(MarSerCal(j,:));
        end
    end
end