classdef SDP1 < handle
        methods (Static = true)
        %% Get objs
        function PopObj = obj(PopDec)
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            y_t = Global.y(Global.NR).yy;
            partg = (PopDec-y_t(1:size(PopDec,1),:)).^2;
            g = sum(partg(:,Global.M+1:Global.D),2);
            Allcumid = 1:1:Global.M;
            PopObj = zeros([size(PopDec,1),Global.M]);
            for j=1:Global.M
                cumid   = Allcumid; cumid(j) = [];
                Cumpart = (cumprod(PopDec(:,cumid),2)).^(1/(Global.M-1));
                Cumpart = Cumpart(:,end);
                PopObj(:,j) = (1+g).*PopDec(:,j)./Cumpart;
            end
        end
       %% Optima PopDec
        function ChangeDec()
            global Global
            t = floor(Global.Evaluated/Global.T)/Global.nt;
            y_told  = Global.y(Global.NR).yy;
            Rnd     = rand([size(y_told,1),Global.D]);
            x_t     = y_told + 5*(Rnd-0.5)*sin(0.5*pi*t);
            Rid     = [find(x_t<0); find(x_t>1)];
            x_t(Rid)= rand([1,length(Rid)]);
            Global.y(Global.NR+1).yy = x_t;              
        end
        
        %%
        function [PopDec,Nref,y_t] = OptimalDec()
            global Global
            y_t = repmat(linspace(1,Global.D,Global.D),Global.Nr,1)/Global.D;
            N = size(y_t,1);
            [UV, Nref]= UniformPoints(N/10^Global.M, 2);
            UV = UV*3+1;
            uv1= repmat(UV(:,1),100,1);
            uv2= repmat(UV(:,1),1,100)';
            UV = [uv1,uv2(:)];
            Nref = Nref*10^Global.M;
            PopDec    = zeros([Nref,Global.D]);
            PopDec(:,1:Global.M) = UV;
            PopDec(:,Global.M+1:Global.D) = y_t(1:Nref, Global.M+1:Global.D);
        end
        
        %% Get reference points
        function [Ref, Nref] = RefPoints()
            global Global
            [OpDec, Nref, y_t] = eval([Global.Problem '.OptimalDec()']);
            partg = (OpDec-y_t).^2;
            g = sum(partg(:,Global.M+1:Global.D),2);
            Allcumid = 1:1:Global.M;
            Ref = zeros([size(OpDec,1),Global.M]);
            for j=1:Global.M
                cumid   = Allcumid; cumid(j) = [];
                Cumpart = (cumprod(OpDec(:,cumid),2)).^(1/(Global.M-1));
                Cumpart = Cumpart(:,end);
                Ref(:,j) = (1+g).*OpDec(:,j)./Cumpart;
            end
        end
    end
end