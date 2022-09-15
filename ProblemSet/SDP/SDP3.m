classdef SDP3 < handle
        methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            pt= floor(5*abs(sin(pi*t)));
            y = PopDec-cos(t);
            partg = 4*y.^2-cos(2*pt*pi*y)+1;
            g = sum(partg(:, Global.M:Global.D), 2);
            PopObj = zeros([size(PopDec,1),Global.M]);   
            for j=1:Global.M
                if j == Global.M
                    Cumpart = cumprod(PopDec + 0.05*sin(6*pi*PopDec),2);
                    Cumpart = Cumpart(:,Global.M-1);
                    PopObj(:,j) = (1+g).*Cumpart;
                else
                    if j >= 2
                        Cumpart = cumprod(PopDec+0.05*sin(6*pi*PopDec),2);
                        Cumpart = Cumpart(:,j-1);
                    else
                        %Cumpart = PopDec(:,j)+0.05*sin(6*pi*PopDec(:,j));
                        Cumpart = 1;
                    end
                    PopObj(:,j) = (1+g).*(1-PopDec(:,j)+0.05*sin(6*pi*PopDec(:,j))).*Cumpart;
                end
            end
        end
       %% Optima PopDec
        function [PopDec,Nref] = OptimalDec()
            global Global
            if Global.M > 2
                [UV, Nref]= UniformPoints(Global.Nr/10^(Global.M-1), Global.M-1);
                uv1= repmat(UV(:,1),10^(Global.M-1),1);
                uv2= repmat(UV(:,1),1,10^(Global.M-1))';
                UV = [uv1,uv2(:)];
                Nref = Nref*10^(Global.M-1);
            else
                UV = linspace(0,1,Global.Nr);
                Nref = Global.Nr;
            end
            PopDec    = zeros([Nref,Global.D]);
            PopDec(:,1:Global.M-1) = UV;
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            PopDec(:,Global.M:Global.D) = cos(t);
        end
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            [OpDec, Nref] = eval([Global.Problem '.OptimalDec()']);
            Ref = eval([Global.Problem '.obj(OpDec)']);
        end
    end
end