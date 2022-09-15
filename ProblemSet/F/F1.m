classdef F1 < handle
    methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global
            G = sin(0.5*pi*floor(Global.Evaluated/Global.T)/Global.nt);
            g = 1+sum((PopDec(:,2:end)-G).^2, 2);
            f1= PopDec(:,1);
            f2= g.*(1-sqrt(f1./g));
            PopObj = [real(f1), real(f2)];
        end
        
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            f1 = linspace(0,1,Global.Nr)';
            f2 = 1-sqrt(f1);
            Ref= [f1, f2];
            Nref = Global.Nr;
        end
        
        %% Optima PopDec
        function [PopDec] = OptimaDec(CurPop)
            global Global
            G           = sin(0.5*pi*floor(Global.Evaluated/Global.T)/Global.nt);
            PopDec      = ones(size(CurPop,1), size(CurPop,2)).*G;
            PopDec(:,1) = linspace(0, 1, size(CurPop,1));
        end
    end
end