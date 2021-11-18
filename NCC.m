function [N_cross_correlation] = NCC(x_channel,reference)

%% 
% Input Arguments: 
% x_channel: is one of the three RGB channels.
% reference : is the channel that we do the aligment respect to it.
% normalized cross-correlation (NCC), which is simply the dot product 
% between the two images normalized to have zero mean and unit norm
% the NCC give us the ability to match the difference in the brightness in
% each channel 
% this function manage us to find the best alignment of one of the channels respect to other
% by finding the maximum correlation value

%%


% -inf is vary small undefined small used for first step comparison
checked_value = -inf;

%make the matrix of Shifted_best_alignment as vector by
%reshapes reference matrix using the size vector 1 and [] to have all its values 
reference_vector = reshape(reference, 1, []); 

% The norm of a matrix is a measure of how large its elements are.
% It is a way of determining the “size” of a matrix that is not necessarily
% related to how many rows or columns the matrix has. Matrix Norm The norm
% of a matrix is a real number which is a measure of the magnitude of the matrix.
reference_norm = reference_vector/norm(reference_vector);

for i = -15:15
    for ii = -15:15
        
        % Foreground Image monement inside the for loop i,ii 
        % Use circshift to shift the elements of matrix by i,ii position in each dimension.
         Shifted_best_alignment = circshift(x_channel,[i ii]);
    
        
        % make the matrix of Shifted_best_alignment as vector
        Alignment_vector = reshape(Shifted_best_alignment, 1, []);
        
        % normalize that vector
        Alignment_norm = Alignment_vector/norm(Alignment_vector);
        
        %is the correlation values for each shift by taking the dot product of normalized vectors
        NCC = dot(reference_norm,Alignment_norm);
        
        %to find the maximum correlation value.
        if NCC > checked_value
            checked_value = NCC;
            fitted_img = [i ii];
        end
    end
end
N_cross_correlation = circshift(x_channel,fitted_img);
end