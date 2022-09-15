classdef F9 < handle
    methods (Static = true)
        %%
        function PopObj = obj(PopDec)
            global Global
            LineD = linspace(1, Global.D, Global.D);
            I1 = LineD(1:2:end);
            I2 = LineD(2:2:end);
            a  = 2*cos(pi*(floor(Global.Evaluated/Global.T)/Global.nt-floor(floor(Global.Evaluated/Global.T)/Global.nt)))+2;
            b  = 2*sin(2*pi*(floor(Global.Evaluated/Global.T)/Global.nt-floor(floor(Global.Evaluated/Global.T)/Global.nt)))+2;
            H  = 1.25+0.75*sin(pi*floor(Global.Evaluated/Global.T)/Global.nt);                    
%             if mod(floor(Global.Evaluated/Global.T),2)==0 && size(PopDec,1)== Global.N           
%                 RealPopDec  = PopDec;
%                 PopDec(:,1) = linspace(a, a+1, size(PopDec,1));
%                 PopDec(:, 2:Global.D) = b+1-abs(PopDec(:,1)-a).^(H+LineD(2:Global.D)/Global.D);  
%                 yi = PopDec-b-1+abs(PopDec(:,1)-a).^(H+LineD/Global.D);
%                 yi(:,1) = 0;
%                 f1 = abs(PopDec(:,1)-a).^H+sum(yi(:,I1).^2,2);
%                 f2 = abs(PopDec(:,1)-a-1).^H+sum(yi(:,I2).^2,2);
%                 figure();
%                 scatter(f1,f2);
%                 PopDec = RealPopDec;
%             end
            yi = PopDec-b-1+abs(PopDec(:,1)-a).^(H+LineD/Global.D);
            yi(:,1) = 0;
            f1 = abs(PopDec(:,1)-a).^H+sum(yi(:,I1).^2,2);
            f2 = abs(PopDec(:,1)-a-1).^H+sum(yi(:,I2).^2,2);
            PopObj = [real(f1), real(f2)];
        end
        
        %%
        function [Ref, Nref] = RefPoints()
            global Global
            S  = linspace(0,1,Global.Nr)';
            H  = 1.25+0.75*sin(pi*floor(Global.Evaluated/Global.T)/Global.nt);
            f1 = S.^H;
            f2 = (1-S).^H;
            Ref= [f1,f2];
            %scatter(f1, f2);
            Nref = Global.Nr;
        end
        
        %%
        function [PopDec] = OptimaDec(CurPop)
            global Global
            LineD = linspace(1, Global.D, Global.D);
            a  = 2*cos(pi*(floor(Global.Evaluated/Global.T)/Global.nt-floor(floor(Global.Evaluated/Global.T)/Global.nt)))+2;
            b  = 2*sin(2*pi*(floor(Global.Evaluated/Global.T)/Global.nt-floor(floor(Global.Evaluated/Global.T)/Global.nt)))+2;
            H  = 1.25+0.75*sin(pi*floor(Global.Evaluated/Global.T)/Global.nt);
            PopDec(:,1) = linspace(a, a+1, size(CurPop,1));
            PopDec(:, 2:Global.D) = b+1-abs(PopDec(:,1)-a).^(H+LineD(2:Global.D)/Global.D);
        end
    end
end