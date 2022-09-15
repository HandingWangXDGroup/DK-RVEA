classdef FDA3 < handle
    %D = 30
    methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global;
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            G = abs(sin(0.5*pi*t));
            F = 10.^(2*sin(0.5*pi*t));
            PopObj = zeros([size(PopDec,1),Global.M]);
            PopObj(:,1) = sum((PopDec(:,1:5)).^F , 2);
            
            g = 1 + G + sum( (PopDec(:,6:end)-G).^2, 2 );
            h = 1- sqrt(PopObj(:,1)./g);
            PopObj(:,2) = g.*h+1;
        end
       %% Optima PopDec
        function [PopDec,Nref] = OptimalDec()
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            UV = linspace(0,1,Global.Nr);
            Nref = Global.Nr;
            PopDec    = zeros([Nref,Global.D]);
            PopDec(:,1) = UV;
            G = abs(sin(0.5*pi*t));
            PopDec(:,2:Global.D) = G;
        end
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            [OpDec, Nref] = eval([Global.Problem '.OptimalDec()']);
            Ref = eval([Global.Problem '.obj(OpDec)']);
        end
    end
end