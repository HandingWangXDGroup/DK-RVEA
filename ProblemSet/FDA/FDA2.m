classdef FDA2 < handle
    %D = 31
    methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            H = 0.75 + 0.7*sin(0.5*pi*t);
            g = 1+ sum(PopDec(:,2:Global.D-15).^2, 2);
            PopObj = zeros([size(PopDec,1),Global.M]);
            PopObj(:,1) = PopDec(:,1);
            Uppart = (H+ sum( (PopDec(:,Global.D-14:end)-H).^2, 2) ).^(-1);
            h = 1- (PopDec(:,1)./g).^Uppart;
            PopObj(:,2) = g.*h;
        end
       %% Optima PopDec
        function [PopDec,Nref] = OptimalDec()
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            UV = linspace(0,1,Global.Nr);
            Nref = Global.Nr;
            PopDec    = zeros([Nref,Global.D]);
            PopDec(:,1) = UV;
            H = 0.75 + 0.7*sin(0.5*pi*t);
            PopDec(:,Global.D-14:Global.D) = H;
        end
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            [OpDec, Nref] = eval([Global.Problem '.OptimalDec()']);
            Ref = eval([Global.Problem '.obj(OpDec)']);
        end
    end
end