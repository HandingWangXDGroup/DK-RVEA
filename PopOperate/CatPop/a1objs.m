function A1Obj = a1objs(A1)
    global Global
    N     = length(A1{1});
    A1Obj = zeros([N,Global.M]);
    for j=1:Global.M
        A1Obj(:,j) = A1{j}.objs;
    end
end