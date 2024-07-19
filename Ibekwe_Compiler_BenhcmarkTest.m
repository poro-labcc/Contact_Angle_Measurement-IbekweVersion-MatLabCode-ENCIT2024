clc; clear; close all;

dbstop if error

tic

minR             = 1.5;
SMALL            = 1e-10;
plotSurfaces     = 0;
plotSearchradius = 0;


%%%%%%%%%%%%%%%%%%%%%%%%% Specify input parameters
%specify maximum fitting error
maxErr           = 2;


Dir    = '/home/usuario/ENCIT_2024'
Radius = [ 7, 14, 28, 56];
Size   = [38, 52, 80,136];
Type   = [ 0,  1,  2,  3];
Angle = 00:10:180;

for i = 1:length(Radius)
    radius = Radius(i);
    X = Size(i);
    Y = Size(i);
    Z = Size(i);
    size = Size(i);
    for j = 1:length(Type)
	type = Type(j);
        for k = 1:length(Angle)
	    angle = Angle(k)
            %specify mean grain diameter (in microns)
            dg = 2*radius; 
            
            %specify resolution (in microns)
            Res = 1; 
            
            %obtain searchRadius R1 and R2
            [R1, R2] = fun_obtainR1andR2(dg, Res);

            filename = sprintf('%s/Benchmark/T%dR%dx%d/T%d_R%d_A%d_x%d.raw', Dir, type, radius, size, type, radius, angle, size);
            output_file_name = sprintf('%s/Medições/Ibewke/T%dR%dx%d_inv/T%d_R%d_A%d_x%d_inv.txt', Dir, type, radius, size, type, radius, angle, size);
            output_file_name_all = sprintf('%s/Medições/Ibewke/T%dR%dx%d_inv/T%d_R%d_A%d_x%d_all_inv.mat', Dir, type, radius, size, type, radius, angle, size);
            [P] = readRawFile(filename, X, Y, Z);
            P(P == 0) = 3;
%            P = P + (P == 1) - (P == 2)*2 + (P == 2); %Change reference fluid
            
            nR = length(R1);
            nCpoints     = zeros(nR, 1);
            ThetaModelAv = zeros(nR, 1);
            ThetaModelSt = zeros(nR, 1);
            
            for iR = 1 : nR
                 [ThetaModel, cp] = fun_computeCA(P, R1(iR), R2, minR, maxErr, SMALL, plotSurfaces, plotSearchradius); 
                                                      
                 nCpoints(iR)    = sum(isfinite(ThetaModel));  
                 ThetaModelAv(iR)= nanmean(ThetaModel);
                 ThetaModelSt(iR)= nanstd(ThetaModel);
                   
            end
            save(output_file_name, 'ThetaModel', '-ascii');
            save(output_file_name_all, 'R1', 'R2', 'nCpoints', 'cp', 'ThetaModel', 'ThetaModelAv', 'ThetaModelSt');
                        
            toc        
        
        end
    end
end
