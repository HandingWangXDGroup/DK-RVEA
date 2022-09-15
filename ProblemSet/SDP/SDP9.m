classdef SDP9 < handle
        methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            Gt= abs(sin(0.5*pi*t));
            pt= floor(6*Gt);
            partg = (PopDec-1/pi*abs(atan(cot(3*pi*t^2)))).^2;
            g = sum(partg(:,Global.M:Global.D),2);
            PopObj = zeros([size(PopDec,1),Global.M]);
            for j=1:Global.M
                if j == Global.M
                    Sumpart = (sin(0.5*pi*PopDec)).^2 + sin(0.5*pi*PopDec).* (cos(pt*pi*PopDec)).^2;
                    PopObj(:,j) = sum(Sumpart(:,1:Global.M-1),2) + Gt;
                else
                    PopObj(:,j) = (1+g).* (cos(0.5*pi*PopDec(:,j))).^2 + Gt;
                end
            end
        end
       %% Optima PopDec
        function [PopDec,Nref] = OptimalDec()
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            if Global.M > 2
                [UV, Nref]= UniformPoints(Global.Nr, Global.M-1);
            else
                UV = linspace(0,1,Global.Nr);
                Nref = Global.Nr;
            end
            PopDec    = zeros([Nref,Global.D]);
            PopDec(:,1:Global.M-1) = UV;
            PopDec(:,Global.M:Global.D) = 1/pi*abs(atan(cot(3*pi*t^2)));
        end
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            [OpDec, Nref] = eval([Global.Problem '.OptimalDec()']);
            Ref = eval([Global.Problem '.obj(OpDec)']);
        end
    end
end