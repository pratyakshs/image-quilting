function [ best_patch ] = quilt_left_overlap(overlap, Im, patch_size, iters, target, alpha, beta, send_t, mode)
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
        overlap_error = single(patch(:, 1:overlap_size(2), :)) - single(overlap);
        sum = 0;
        for j = 1:patch_size(1)
            for k = 1:patch_size(2)
                temp = (norm(target(j, k, :)) - norm(patch(j,k,:)))^{2};
                if mode == 1
                    temp = temp * beta + (1 - beta) * (norm(send_t(j, k, :)) - norm(patch(j,k,:)))^{2};
                end
                sum = sum + temp;
            end
        end
        l2_error = alpha * norm(overlap_error(:)) + (1 - alpha) * sum;
        if l2_error < best_error
            best_error = l2_error;
            best_patch = patch;
        end
    end
    best_patch = left_overlap_cut(best_patch, overlap);
end