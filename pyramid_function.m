function [shift] = pyramid_function(x_channel, reference, N)

%%
% Input Arguments: 
% x_channel: is one of the three RGB channels.
% reference : is the channel that we do the alignment respect to it
% using this function to implement a faster search procedure such as 
% An image pyramid represents the image at multiple scales (usually scaled by 
% a factor of 2) and the processing is done sequentially starting from the coarsest scale (smallest 
% image) and going down the pyramid, updating our estimate as we go.

%%
if N == 0
    % would execute for the top of the pyramid image
    [f1,f2] = align_Img(x_channel, reference, 15,0.2); 
    shift =f2;
else
    
    
    %impyramid computes a Gaussian pyramid reduction.
    
    %'reduce' change the size down of img is ceil(M/2)-by-ceil(N/2). 
    x_channel = impyramid(x_channel, 'reduce');
    reference =  impyramid(reference, 'reduce');
    
    %recursion
    shift = pyramid_function(x_channel, reference, N-1)*2; 
    x_channel = circshift(x_channel, shift);
    
    [f1,f2]  =align_Img(x_channel, reference, 15, 0.2);
    shift=shift+f2;
    
end





