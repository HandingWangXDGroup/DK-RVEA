classdef F4 < handle
    methods (Static = true)
        %%
        function PopObj = obj(PopDec)
            global Global 
            G  = sin(0.5*pi*floor(Global.Evaluated/Global.T)/Global.nt);
            g  = abs(sum((PopDec(:,3:end)-G).^2, 2));
            f1 = (1+g).*cos(0.5*pi.*PopDec(:,2)).*cos(0.5*pi.*PopDec(:,1));
            f2 = (1+g).*cos(0.5*pi.*PopDec(:,2)).*sin(0.5*pi.*PopDec(:,1));
            f3 = (1+g).*sin(0.5*pi.*PopDec(:,2));
            PopObj = [real(f1), real(f2), real(f3)];
        end
        
        %%
        function [Ref, Nref] = RefPoints()
            global Global
            [UV, Nref] = UniformPoints(Global.Nr/100, 2);
            UV = UV*pi/2;
            uv1= repmat(UV(:,1),100,1);
            uv2= repmat(UV(:,1),1,100)';
            UV = [uv1,uv2(:)];
            f1 = cos(UV(:,1)).*cos(UV(:,2));
            f2 = cos(UV(:,1)).*sin(UV(:,2));
            f3 = sin(UV(:,1));
            Ref= [f1,f2,f3];
            Nref = Nref*100;
        end
        
        %%
        function [PopDec] = OptimaDec(CurPop)
            global Global
            [UV, Nref] = UniformPoints(Global.Nr/100, 2);
            G          = sin(0.5*pi*floor(Global.Evaluated/Global.T)/Global.nt);                       
            uv1= repmat(UV(:,1),100,1);
            uv2= repmat(UV(:,1),1,100)';
            XX = [uv1,uv2(:)];
            PopDec     = ones(size(XX,1), size(CurPop,2)).*G; 
            PopDec(:, 1:2) = XX;
        end
    end
end