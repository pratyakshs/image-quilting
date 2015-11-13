function [ best_patch ] = quilt_top_overlap(overlap, Im, patch_size, iters)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    best_error = inf;
    best_patch = zeros(patch_size);
    overlap_size = size(overlap);
    [r, c, ~] = size(Im);
    for i=1:iters
        r_take = randi([1, r - patch_size(1) + 1], 1, 1);
        c_take = randi([1, c - patch_size(2) + 1], 1, 1);
        patch = Im(r_take:r_take+patch_size(1)-1, c_take:c_take+patch_size(2)-1, :);
        overlap_error = single(patch(1:overlap_size(1), :, :)) - single(overlap);
        l2_error = norm(overlap_error(:));
        if l2_error < best_error
            best_error = l2_error;
            best_patch = patch;
        end
    end
    best_patch = top_overlap_cut(best_patch, overlap); 
end
