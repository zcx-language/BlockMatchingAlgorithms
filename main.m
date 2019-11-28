clear all;
clc;


imgI_orig = imread("../Image/31.jpg");
if ndims(imgI_orig) == 3
    imgI = double(rgb2gray(imgI_orig));
else
    imgI = double(imgI_orig);
end


imgP_orig = imread("../Image/32.jpg");

if ndims(imgP_orig) == 3
    imgP = double(rgb2gray(imgP_orig));
else 
    imgP = double(imgP_orig);
end

% imshow(imgI);
% imshow(imgP);

mbSize = 16;
p = 7;

axis tight;
set(gca, 'box', 'on')

% subplot(3, 2, 1);
% imshow(uint8(imgP),'InitialMagnification', 'fit');
% title('Target');
% hold on;
% 
% subplot(3, 2, 2);
% imshow(uint8(imgI),'InitialMagnification', 'fit');
% title('Inference');
% hold on;

% [ES_motion_vect, ES_computations, ES_time] = motionEstES(imgP, imgI, mbSize, p);
% ES_img_comp = motionComp(imgI, ES_motion_vect, mbSize);
% fprintf('Exhaustive Search Time:%fs\n', ES_time);
% fprintf('PSNR:%f\n', imgPSNR(imgP,ES_img_comp,255));
% fprintf('Computations:%f\n', ES_computations);
% subplot(3, 2, 3);
% imshow(uint8(ES_img_comp),'InitialMagnification', 'fit');
% title('Exhaustive Search');
% hold on;


% [TSS_motion_vect, TSS_computations, TSS_time] = motionEstTSS(imgP, imgI, mbSize, p);
% TSS_img_comp = motionComp(imgI, TSS_motion_vect, mbSize);
% fprintf('Three Step Search Time:%fs\n', TSS_time);
% fprintf('PSNR:%f\n', imgPSNR(imgP,TSS_img_comp,255));
% fprintf('Computations:%f\n', TSS_computations);
% subplot(3, 2, 4);
% imshow(uint8(TSS_img_comp),'InitialMagnification', 'fit');
% title('Three Step Search');
% hold on;

% [TDLS_motion_vect, TDLS_computations, TDLS_time] = motionEstTDLS(imgP, imgI, mbSize, p);
% TDLS_img_comp = motionComp(imgI, TDLS_motion_vect, mbSize);
% fprintf('2D Logarithmic Search Time:%fs\n', TDLS_time);
% fprintf('PSNR:%f\n', imgPSNR(imgP,TDLS_img_comp,255));
% fprintf('Computations:%f\n', TDLS_computations);
% subplot(3, 2, 5);
% imshow(uint8(TDLS_img_comp),'InitialMagnification', 'fit');
% title('2D Logarithmic Search');
% hold on;


[CS_motion_vect, CS_computations, CS_time] = motionEstCS(imgP, imgI, mbSize, p);
CS_img_comp = motionComp(imgI, CS_motion_vect, mbSize);
fprintf('Conjugate Search Time:%fs\n', CS_time);
fprintf('PSNR:%f\n', imgPSNR(imgP,CS_img_comp,255));
fprintf('Computations:%f\n', CS_computations);
subplot(3, 2, 6);
imshow(uint8(CS_img_comp),'InitialMagnification', 'fit');
title('Conjugate Search');
hold on;








