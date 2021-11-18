function [aligned_channel,shift] = align_Img(foreground_channel,Background_channel,r,p)

%% 
% Input Arguments:
% foreground_channel: is one of the three RGB channels.
% Background_channel: is anther one of the three RGB channels .
% r : is the rotation window size used to search over certain channel
% p : is the cropping border Precentage

% using the function 'SSD=sum(sum(image1-image2).^2)' after cropping the
% background channel then trying to shift the foreground channel from
%[-r:r -r;r] and after evey shift we crop this channel then checking the
%ssd function and take the best of them.
%
%%

% inf is vary large undefined number used for first step comparison
checked_value = inf;  
% cropp background image to aligning the forground on it.
cropped_Background = crop(Background_channel,p);

for i = -r:r
    for j = -r:r
        
        %Foreground Image movement inside the for loop i,j 
        % Use circshift to shift the elements of matrix by i,j position in each dimension.
        Shifted_foreground = circshift(foreground_channel,[i j]);
        
        % crpping the shifted foreground image
        Shifted_foreground_cropped = crop(Shifted_foreground,p);
        
        % the sum of squared differences function
        ssd=sum(sum(cropped_Background-Shifted_foreground_cropped).^2);
        
        % copmparison to find best fitted forground to background image
        % by find the minmum differences value.
        if ssd < checked_value
            checked_value = ssd;
            fitted_img = [i j];
        end
    end
end

aligned_channel = circshift(foreground_channel,fitted_img);
shift= fitted_img;
end