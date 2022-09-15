classdef F2 < handle
    methods (Static = true)
        %%
        function PopObj = obj(PopDec)
            global Global;
            H = 1.25+0.75*sin(0.5*pi*floor(Global.Evaluated/Global.T)/Global.nt);
            %disp(H);
            g = 1+9*sum((PopDec(:,2:end)).^2, 2);
            f1= PopDec(:,1);
            f2= g.*(1-(f1./g).^H);
            PopObj = [real(f1), real(f2)];
        end
        
        %%
        function [Ref, Nref] = RefPoints()
            global Global
            f1 = linspace(0,1,Global.Nr)';
            H  = 1.25+0.75*sin(0.5*pi*floor(Global.Evaluated/Global.T)/Global.nt);
            f2 = 1-f1.^H;
            Ref= [f1,f2];
            Nref = Global.Nr;
        end
        
        %%
        function [PopDec] = OptimaDec(CurPop)
            PopDec      = zeros(size(CurPop,1), size(CurPop,2));
            PopDec(:,1) = linspace(0, 1, size(CurPop,1));
        end
    end
end