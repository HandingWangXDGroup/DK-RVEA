function RenameFile
    file = dir();
    len  = length(file);
    for i = 1 : len
        oldname = file(i).name;
        newname = [oldname(1:find(oldname=='.')-1), '2', '.m'];
        eval(['!rename' 32 oldname 32 newname]);
    end
end