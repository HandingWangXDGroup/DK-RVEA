classdef F8 < handle
    methods (Static = true)
        %%
        function PopObj = obj(PopDec)
            global Global
            H  = 1.25+0.75*sin(pi*floor(Global.Evaluated/Global.T)/Global.nt);
            G  = sin(0.5*pi*floor(Global.Evaluated/Global.T)/Global.nt);
            
%             XX = UniformPoints(Global.N, 2);
%             PopDec(:, 1:2) = XX;
%             PopDec(:, 3:Global.D) = repmat(((PopDec(:,1)+PopDec(:,2))/2).^H+G, 1, Global.D-2);
            g  = sum((PopDec(:,3:Global.D)-((PopDec(:,1)+PopDec(:,2))/2).^H-G).^2, 2);
            

            
            f1 = (1+g).*cos(0.5*pi*PopDec(:,2)).*cos(0.5*pi*PopDec(:,1));
            f2 = (1+g).*cos(0.5*pi*PopDec(:,2)).*sin(0.5*pi*PopDec(:,1));
            f3 = (1+g).*sin(0.5*pi*PopDec(:,2));
            PopObj = [real(f1), real(f2), real(f3)];
            
            %scatter3(f3, f2, f1);
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
            %scatter3(f3, f2, f1);
        end
        
        %%
        function [PopDec] = OptimaDec(CurPop)
            global Global
            H  = 1.25+0.75*sin(pi*floor(Global.Evaluated/Global.T)/Global.nt);
            G  = sin(0.5*pi*floor(Global.Evaluated/Global.T)/Global.nt);
            %XX = UniformPoints(size(CurPop,1), 2);
            XX(:,1) = linspace(0,1,size(CurPop,1));
            XX(:,2) = XX(:,1);
            PopDec(:, 1:2) = XX;
            PopDec(:, 3:Global.D) = repmat(((PopDec(:,1)+PopDec(:,2))/2).^H+G, 1, Global.D-2);
        end
    end
end
