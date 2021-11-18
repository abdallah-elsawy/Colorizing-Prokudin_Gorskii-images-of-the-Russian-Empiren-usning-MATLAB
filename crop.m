function [Crop] = crop(img,p)

%% cropping Image img with p aspect percentage 
%%
crop_img = floor(p*size(img));
cropped_H = crop_img(1);
cropped_W = crop_img(2);
new_img_H = size(img,1) - cropped_H;
new_img_W = size(img,2) - cropped_W;
Crop = img(cropped_H:new_img_H,cropped_W:new_img_W);
end