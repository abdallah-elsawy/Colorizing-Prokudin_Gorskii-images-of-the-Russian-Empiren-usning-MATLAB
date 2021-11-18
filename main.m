
%% Mini Project 1: Colorizing ProkudinGorskii images of the Russian Empire
%%
%The goal of this mini project is to learn to work with images in MATLAB by taking the digitized 
%Prokudin-Gorskii glass plate images and automatically producing a color image with as few 
%visual artifacts as possible. In order to do this, we will need to extract the three color channel 
%images, place them on top of each other, and align them so that they form
%a single RGB color image

%%

clear all; clc; 

%% import image and divide it into three channels to create unaligned image
%% 

% read the image

%img = imread('00125v.jpg'); 
%img = imread('00149v.jpg'); 
img = imread('00153v.jpg'); 
%img = imread('00351v.jpg'); 
%img = imread('00398v.jpg'); 
%img = imread('01112v.jpg'); 

% convert it to double
img = im2double(img);  %This means that we have not lost precision

%divide the image into three channels to 
[y, x] = size(img);
y = floor(y/3);



R = img(2*y+1:3*y,:);
figure(1);
imshow(R);
title('channel R');
%imwrite(R,'00125v_channel_R.jpg');


G = img(y+1:2*y,:);
figure(2);
imshow(G);
title('channel B');
%imwrite(G,'00125v_channel_B.jpg');


B = img(1:y,:);
figure(3);
imshow(B);
title('channel G');
%imwrite(B,'00125v_channel_G.jpg');





%% align two of the channels to the third (try different orders) and show them
%%

%RGB, RBG, GBR, GRB,BRG, BGR

figure(4);


RGB = cat(3,R,G,B);
%imwrite(RGB,'00125v_unaligned_RGB.jpg');
%figure(4);
subplot(3,2,1);
imshow(RGB);
title('unaligned RGB image');

RBG = cat(3,R,B,G);
%imwrite(RBG,'00125v_unaligned_RBG.jpg');
%figure(5);
subplot(3,2,2);
imshow(RBG);
title('unaligned RBG image');

GBR = cat(3,G,B,R);
%imwrite(GBR,'00125v_unaligned_GBR.jpg');
%figure(6);
subplot(3,2,3);
imshow(GBR);
title('unaligned GBR image');

GRB = cat(3,G,R,B);
%imwrite(GRB,'00125v_unaligned_GRB.jpg');
%figure(7);
subplot(3,2,4);
imshow(GRB);
title('unaligned GRB image');

BRG = cat(3,B,R,G);
%imwrite(BRG,'00125v_unaligned_BRG.jpg');
%figure(8);
subplot(3,2,5);
imshow(BRG);
title('unaligned BRG image');

BGR = cat(3,B,G,R);
%imwrite(BGR,'00125v_unaligned_BGR.jpg');
%figure(9);
subplot(3,2,6);
imshow(BGR);
title('unaligned BGR image');



%% Using the sum of squared differences (SSD) to score how well the images match.
%%
% we will take every time one of the channel for the background and one of other
% channels to be the foreground and applying the function 'align_Img on
% every combination of them to find the best aligned images

%%

p = 0.09; % the cropping border Precentage
r = 4;    % rotation window


% R is the Background channel and B,G is the foreground channel
align_B2 = align_Img(B,R,r,p);
align_G2 = align_Img(G,R,r,p);
aligned_RGB = cat(3,R,align_G2,align_B2);                    % then Concatenate the Background channel R with each of G,B
%imwrite(aligned_RGB,'00125v_aligned_foregrpund_R.jpg');   % save the aligned RGB image and show it
figure(10);
imshow(aligned_RGB);
title('Aligned RGB image for background R');

% if G is the Background channel
align_B2 = align_Img(B,G,r,p);
align_R2 = align_Img(R,G,r,p);
aligned_RGB = cat(3,align_R2,G,align_B2);
%imwrite(aligned_RGB,'00125v_aligned_foregrpund_G.jpg');
figure(11);
imshow(aligned_RGB);
title('Aligned RGB image for background G');

% if B is the Background channel
align_G2 = align_Img(G,B,r,p);
align_R2 = align_Img(R,B,r,p);
aligned_RGB = cat(3,align_R2,align_G2,B);
%imwrite(aligned_RGB,'00125v_aligned_foregrpund_B.jpg');
figure(12);
imshow(aligned_RGB);
title('Aligned RGB image for background B');




%% Improved SSD method
%%

% when we see the previous results of the SSD method 
% we find there is unneeded border which effect on our results
% so we should crop this channels with some ratio and redo the SSD method
% on the new channels.

%%


R=crop(R,0.15);
B=crop(B,0.15);
G=crop(G,0.15);

% if R is the Background channel
align_B2 = align_Img(B,R,r,p);
align_G2 = align_Img(G,R,r,p);
aligned_RGB2 = cat(3,R,align_G2,align_B2); 
%imwrite(aligned_RGB2,'00125v_Improved_SSD_foregrpund_R.jpg');
figure(13);
imshow(aligned_RGB2);
title('Improved SSD image for background R');

% if G is the Background channel
align_B2 = align_Img(B,G,r,p);
align_R2 = align_Img(R,G,r,p);
aligned_RGB2 = cat(3,align_R2,G,align_B2);
%imwrite(aligned_RGB2,'00125v_Improved_SSD_foregrpund_G.jpg');
figure(14);
imshow(aligned_RGB2);
title('Improved SSD image for background G');

% if B is the Background channel
align_G2 = align_Img(G,B,r,p);
align_R2 = align_Img(R,B,r,p);
aligned_RGB2 = cat(3,align_R2,align_G2,B);
%imwrite(aligned_RGB2,'00125v_Improved_SSD_foregrpund_B.jpg');
figure(15);
imshow(aligned_RGB2);
title('Improved SSD image for background B');



%% Using the normalized cross-correlation (NCC) 
%%
% to over come the problem of brightness we use NCC method
% this function manage us to find the best alignment of one of the channels respect to other
% we realize that the image did not have the same brightness so to match
% them we should use matric like normalized cross-correlation (NCC), which is 
% simply the dot product between the two images normalized to have zero mean and unit norm
% MATLAB function normxcorr2).

%%


% R is the reference channel and G,B is the alignment channel
NCC_G = NCC(G,R);
NCC_B = NCC(B,R);
NCC_RGB = cat(3,R,NCC_G,NCC_B);
%imwrite(NCC_RGB,'00125v_NCC_reference_R.jpg');
figure(16); 
imshow(NCC_RGB);
title('NCC RGB image with Reference R');

% G is the reference channel and R,B is the alignment channel
NCC_R = NCC(R,G);
NCC_B = NCC(B,G);
NCC_RGB = cat(3,NCC_R,G,NCC_B);
%imwrite(NCC_RGB,'00125v_NCC_reference_G.jpg');
figure(17); 
imshow(NCC_RGB);
title('NCC RGB image with Reference G');

% B is the reference channel and G,R is the alignment channel
NCC_G = NCC(G,B);
NCC_R = NCC(R,B);
NCC_RGB = cat(3,NCC_R,NCC_G,B);
%imwrite(NCC_RGB,'00125v_NCC_reference_B.jpg');
figure(18); 
imshow(NCC_RGB);
title('NCC RGB image with Reference B');


%% Multiscale alignment by using an image pyramid.
%%
% using this approach to implement a faster search procedure such as 
% An image pyramid represents the image at multiple scales (usually scaled by 
% a factor of 2) and the processing is done sequentially starting from the coarsest scale (smallest 
% image) and going down the pyramid, updating our estimate as we go.

%%



% R is the reference channel 
shifted_G = pyramid_function(G, R, 3);
pyramid_G = circshift(G, shifted_G);
shifted_B = pyramid_function(B, R, 3);
pyramid_B = circshift(B, shifted_B);
pyramid_RGB = cat(3,R,pyramid_G,pyramid_B);
%imwrite(pyramid_RGB, '00125v_pyramid_reference_R.jpg')
figure(19); 
imshow(pyramid_RGB);
title('pyramid RGB with refernce R');

% G is the reference channel 
shifted_R = pyramid_function(R, G, 3);
pyramid_R = circshift(R, shifted_R);
shifted_B = pyramid_function(B, G, 3);
pyramid_B = circshift(B, shifted_B);
pyramid_RGB = cat(3,pyramid_R,G,pyramid_B);
%imwrite(pyramid_RGB, '00125v_pyramid_reference_G.jpg')
figure(20); 
imshow(pyramid_RGB);
title('pyramid RGB with refernce G');

% B is the reference channel
shifted_R = pyramid_function(R, B, 3);
pyramid_R = circshift(R, shifted_R);
shifted_G = pyramid_function(G, B, 3);
pyramid_G = circshift(G, shifted_G);
pyramid_RGB = cat(3,pyramid_R,pyramid_G,B);
%imwrite(pyramid_RGB, '00125v_pyramid_reference_B.jpg')
figure(21); 
imshow(pyramid_RGB);
title('pyramid RGB with refernce B');




