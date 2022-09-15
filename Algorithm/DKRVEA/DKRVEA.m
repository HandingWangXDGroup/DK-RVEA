function DKRVEA()
    global Global;

    %% Parameter setting of K-RVEA
    alpha = 2;
    wmax  = 20;
    mu    = 5;
    [V0,Global.N] = UniformPoint(Global.N,Global.M);
	V     = V0;
    NI    = 200;      
    %% Generate the reference points and population
    Global.PopObs    = LHS_sam(Global.D*2);   %%%Generate the initial points
    Global.ObsDec    = decs(Global.PopObs);   %%%Generate the observation points
    Global.Rs        = 3;                     %%%The width of the AE model
    Global.NR        = 1;                     %%%Current time step number
    Global.SerNum = 10;                       %%%The length of building the AE model
    Global.MultiR    = struct();
    Global.MultiR(Global.NR).ObsObj = objs(Global.PopObs);
    A1               = Global.PopObs;
    THETA            = 5.*ones(Global.M,Global.D);
    Model            = cell(1,Global.M);
    PopDec           = RandSamp(Global.N);
    PopObj           = zeros([Global.N, Global.M]);
    Population       = PopStruct(PopDec, PopObj);
    TransFlag        = zeros([1,Global.M]);
    Gen = 1; Rate = 0;
    %% PreTrain the Kriging Models
     A1Dec = decs(A1);
     A1Obj = objs(A1);
     for i = 1 : Global.M
        dmodel     = dacefit(A1Dec,A1Obj(:,i),'regpoly1','corrgauss',THETA(i,:),1e-5.*ones(1,Global.D),100.*ones(1,Global.D));
        Model{i}   = dmodel;
        THETA(i,:) = dmodel.theta;
     end
    %% Optimization
    while Terminate()
        if Global.Evaluated < (Global.NR*Global.T) || Global.Evaluated==0
            %%%The optimization of current time step
            [Population, Model, A1, THETA, V, Rate] = KOptimal3(Model, decs(Population), V, V0, alpha, wmax, mu, NI, THETA, A1, TransFlag, Gen, Rate);            
            Gen = Gen+1;
        else
            %%%Initialize the parameters for optimization at the start of each time step
            Global.HisTrain = struct(); Global.AddData = struct(); Gen = 2; Rate = 0;
            Global = rmfield(Global,'HisTrain'); Global=rmfield(Global,'AddData');
            Global.Evaluated  = Global.NR*Global.T;
            [V0,Global.N]     = UniformPoint(Global.N,Global.M);
            V                 = V0;
            %%%Save the outpop and the IGD value of current time step
            ModelData(A1, Model);  
            Global.NR         = Global.NR+1;    
            THETA             = 5.*ones(Global.M,Global.D);
            [A1, Model, TransFlag] = KHisInitial(THETA, V);
            PopDec            = RandSamp(Global.N);
            PopObj            = zeros([Global.N, Global.M]);
            Population        = PopStruct(PopDec, PopObj);
            disp(['---------',num2str(Global.NR),'-------']);
        end
    end
end