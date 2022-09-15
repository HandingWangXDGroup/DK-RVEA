classdef SDP5 < handle
        methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            Gt= abs(sin(0.5*pi*t));
            y = pi/6*Gt+(pi/2-pi/3*Gt)*PopDec;
            partg = (PopDec-repmat(PopDec(:,1),1,Global.D)*0.5*Gt).^2;
            g = Gt+ sum(partg(:,Global.M:Global.D),2);
            PopObj = zeros([size(PopDec,1),Global.M]);
            for j=1:Global.M
                if j == Global.M
                    Cumpart = cumprod(cos(y(:,1:Global.M-1)),2);
                    Cumpart = Cumpart(:,end);
                    PopObj(:,j) = (1+g).*Cumpart;
                else
                    if j >= 2
                        Cumpart = cumprod(cos(y(:,1:j-1)),2);
                        Cumpart = Cumpart(:,end);
                    else
                        Cumpart = 1;
                    end
                    PopObj(:,j) = (1+g).*sin(y(:,j)).*Cumpart;
                end
            end
        end
       %% Optima PopDec
        function [PopDec,Nref] = OptimalDec()
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            if Global.M > 2
                [UV, Nref]= UniformPoints(Global.Nr/10^(Global.M-1), Global.M-1);
                uv1= repmat(UV(:,1),100,1);
                uv2= repmat(UV(:,1),1,100)';
                UV = [uv1,uv2(:)];
                Nref = Nref*10^(Global.M-1);
            else
                UV = linspace(0,1,Global.Nr);
                Nref = Global.Nr;
            end
            PopDec    = zeros([Nref,Global.D]);
            PopDec(:,1:Global.M-1) = UV;
            PopDec(:,Global.M:Global.D) = repmat(0.5*abs(sin(0.5*pi*t)*PopDec(:,1)),1,Global.D-Global.M+1);
        end
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            [OpDec, Nref] = eval([Global.Problem '.OptimalDec()']);
            Ref = eval([Global.Problem '.obj(OpDec)']);
        end
    end
end