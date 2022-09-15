classdef SDP10 < handle
        methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            r = floor(10*abs(sin(0.5*pi*t)));
            partg = (PopDec-repmat(sin(PopDec(:,1)+0.5*pi*t),1,Global.D)).^2;
            g = sum(partg(:,Global.M:Global.D),2);
            parts = PopDec.^2/(Global.M-1);
            s =sum(parts(:,1:Global.M-1),2);
            PopObj = zeros([size(PopDec,1),Global.M]);
            for j=1:Global.M
                if j == Global.M
                    PopObj(:,j) = (1+g).*(2-s-sqrt(s).*(-sin(2.5*pi*s)).^r);
                else
                    PopObj(:,j) = PopDec(:,j);
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
            PopDec(:,Global.M:Global.D) = repmat(sin(PopDec(:,1)+0.5*pi*t),1,Global.D-Global.M+1);
        end
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            [OpDec, Nref] = eval([Global.Problem '.OptimalDec()']);
            Ref = eval([Global.Problem '.obj(OpDec)']);
        end
    end
end