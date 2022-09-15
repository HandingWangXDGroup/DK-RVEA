function main()
    %------------------------------- Reference --------------------------------
    % Z. Liu, H. Wang, and Y. Jin, Performance Indicator based 
    % Adaptive Model Selection for Offline Data-Driven Multi-Objective 
    % Evolutionary Optimization in IEEE Transactions on Cybernetics.
    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 HandingWangXD Group. Permission is granted to copy and
    % use this code for research, noncommercial purposes, provided this
    % copyright notice is retained and the origin of the code is cited. The
    % code is provided "as is" and without any warranties, express or implied.
    %---------------------------- Parameter setting ---------------------------
    %The parameters can be set in the ParameterInitial.m
    %% AddPath to current document
    global Global
    dbstop if error
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
    %%%DKRVEA is the proposed algorithm
    AlgSet = {'DKRVEA'};
    %%%The test problem is input here
    ProSet = {'F1'};
    Global.Irun = 1;
    for i = 1:length(ProSet)
        for j = 1:length(AlgSet)
            %%%Filename is the file path of the data
            Filename = ['D:\', char(AlgSet(j)), char(ProSet(i)), '-', num2str(Global.Irun), '.mat'];
            Global.filename = Filename;
            if exist(Filename, 'file')==0
                %% Initialize public parameters
                ParameterInitial(char(AlgSet(j)), char(ProSet(i)));
                %% Algorithm start        
                eval([Global.Algorithm, '()']);
            end
        end
    end
end