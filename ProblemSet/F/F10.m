classdef F10 < handle
    methods (Static = true)
        %%
        function PopObj = obj(PopDec)
            global Global
            LineD = linspace(1, Global.D, Global.D);
            I1 = LineD(1:2:end);
            I2 = LineD(2:2:end);
            a  = 2*cos(pi*floor(Global.Evaluated/Global.T)/Global.nt)+2;
            b  = 2*sin(2*pi*floor(Global.Evaluated/Global.T)/Global.nt)+2;
            H  = 1.25+0.75*sin(pi*floor(Global.Evaluated/Global.T)/Global.nt);           
            if floor(Global.Evaluated/Global.T)==0
                yi = PopDec-b-1+abs(PopDec(:,1)-a).^(H+LineD/Global.D);
            elseif ~mod(floor(Global.Evaluated/Global.T), 2)
                yi = PopDec-b-abs(PopDec(:,1)-a).^(H+LineD/Global.D);
            else
                yi = PopDec-b-1+abs(PopDec(:,1)-a).^(H+LineD/Global.D);
            end
            yi(:,1)= 0;
            f1 = abs(PopDec(:,1)-a).^H+sum(yi(:,I1).^2,2);
            f2 = abs(PopDec(:,1)-a-1).^H+sum(yi(:,I2).^2,2);
            PopObj = [f1,f2];
        end
        
        %%
        function [Ref, Nref] = RefPoints()
            global Global
            S  = linspace(0,1,Global.Nr)';
            H  = 1.25+0.75*sin(pi*floor(Global.Evaluated/Global.T)/Global.nt);
            f1 = S.^H;
            f2 = (1-S).^H;
            Ref= [f1,f2];
            Nref = Global.Nr;
        end
        
        %%
        function [PopDec] = OptimaDec(CurPop)
            global Global
            LineD = linspace(1, Global.D, Global.D);
            a  = 2*cos(pi*floor(Global.Evaluated/Global.T)/Global.nt)+2;
            b  = 2*sin(2*pi*floor(Global.Evaluated/Global.T)/Global.nt)+2;
            H  = 1.25+0.75*sin(pi*floor(Global.Evaluated/Global.T)/Global.nt);  
            PopDec                = zeros(size(CurPop,1), size(CurPop,2));
            PopDec(:,1)           = linspace(a, a+1, size(CurPop,1));
            PopDec(:, 2:Global.D) = b+1-abs(PopDec(:,1)-a).^(H+LineD(2:Global.D)/Global.D);
        end
    end
end