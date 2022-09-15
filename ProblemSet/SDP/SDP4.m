classdef SDP4 < handle
        methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            w = sign(rand()-0.5)*floor(6*abs(sin(0.5*pi*t)));
            disx = repmat(PopDec(:,1),1,Global.D) + [zeros([size(PopDec,1),1]), PopDec(:,1:end-1)];
            partg = (PopDec-cos(t+disx)).^2;
            g = sum(partg(:,Global.M:Global.D),2);
            s = sum(PopDec(:,1:Global.M-1)/(Global.M-1), 2);
            PopObj = zeros([size(PopDec,1),Global.M]);
            for j=1:Global.M
                if j == Global.M
                    PopObj(:,j) = (1+g).*(1-s+0.05*sin(w*pi*s));
                elseif j == Global.M-1
                    PopObj(:,j) = (1+g).*(s+0.05*sin(w*pi*s));
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
            PopDec = zeros([Nref,Global.D]);
            PopDec(:,1:Global.M-1) = UV;
            for j=Global.M:Global.D
                PopDec(:,j) = cos(t+PopDec(:,1)+PopDec(:,j-1));
            end
        end
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            [OpDec, Nref] = eval([Global.Problem '.OptimalDec()']);
            Ref = eval([Global.Problem '.obj(OpDec)']);
        end
    end
end