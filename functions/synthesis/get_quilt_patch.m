function [ out_im ] = get_quilt_patch(patch, target, alpha, Im, patch_size, overlap_size, i1, j1, mode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [r, c, ~] = size(Im);
    %overlap_size
    top_overlap = patch(1:overlap_size(1), :, :);
    left_overlap = patch(:, 1:overlap_size(2), :);
    
    if ((i1 == 1) && (j1 == 1))
        % Pick the first patch randomly
        r_take = randi([1, r - patch_size(1)], 1, 1);
        c_take = randi([1, c - patch_size(2)], 1, 1);
        out_im = Im(r_take:r_take+patch_size(1)-1, c_take:c_take+patch_size(2)-1, :);
    elseif (i1 == 1)
        % We're in the top row, consider only the left overlap
        out_im = quilt_left_overlap(left_overlap, Im, patch_size, 200, target, alpha, mode, patch);
    elseif (j1 == 1)
        % We're in the left column, consider only the top overlap
        out_im = quilt_top_overlap(top_overlap, Im, patch_size, 200, target, alpha, mode, patch);
    else
        % In the interior, consider the L-overlap
        out_im = quilt_L_overlap(top_overlap, left_overlap, Im, patch_size, 200, target, alpha, mode, patch);
    end
end
