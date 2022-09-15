function centers = get_center(PopDec, center_num)
%%%Get center points via Kmeans
    [~,centers] = kmeans(PopDec,center_num);
end