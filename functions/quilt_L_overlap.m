function [ best_patch ] = quilt_L_overlap(overlap_top, overlap_left, Im, patch_size, iters)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    best_error = inf;
    best_patch = zeros(patch_size);
    overlap_top_size = size(overlap_top);
    overlap_left_size = size(overlap_left);
    [r, c, ~] = size(Im);
    for i=1:iters
        r_take = randi([1, r - patch_size(1) + 1], 1, 1);
        c_take = randi([1, c - patch_size(2) + 1], 1, 1);
        patch = Im(r_take:r_take+patch_size(1)-1, c_take:c_take+patch_size(2)-1, :);
        overlap_error_top = single(patch(1:overlap_top_size(1), :, :)) - single(overlap_top);
        overlap_error_left = single(patch(:, 1:overlap_left_size(2), :)) - single(overlap_left);
        l2_error = norm([norm(overlap_error_top(:)), norm(overlap_error_left(:))]);
        if l2_error < best_error
            best_error = l2_error;
            best_patch = patch;
        end
    end
    best_patch = left_overlap_cut(best_patch, overlap_left);
    best_patch = top_overlap_cut(best_patch, overlap_top);
end
