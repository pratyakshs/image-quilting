function [ best_patch ] = quilt_L_overlap(overlap_top, overlap_left, Im, patch_size, iters, target, alpha, mode, pt)
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
        error_sum = norm(overlap_error_top(:))^2 + norm(overlap_error_left(:))^2;
        if ~(mode == 0)
            v1 = single(pt(overlap_top_size(1)+1:end,overlap_left_size(2)+1:end,:));
            v1 = v1 - single(patch(overlap_top_size(1)+1:end,overlap_left_size(2)+1:end,:));
            error_sum = error_sum + norm(v1(:))^2;
        end
        %sum = 0;
        V1 = mean(single(target), 3);
        V2 = mean(single(patch), 3);
        corr_err = sum(sum((V1 - V2).^2));
        %for j = 1:patch_size(1)
        %    for k = 1:patch_size(2)
        %        v1 = norm(reshape(single(target(j, k, :)), [3 1]));
        %        v2 = norm(reshape(single(patch(j, k, :)), [3 1]));
        %        temp = (v1 - v2)^2;
        %        if mode == 1
        %            v3 = norm(reshape(single(send_t(j, k, :)), [3 1]));
        %            temp = temp * beta + (1 - beta) * (v3 - v2)^2;
        %        end
        %        sum = sum + temp;
        %    end
        %end
        l2_error = alpha * sqrt(error_sum)  + (1 - alpha) * corr_err;
        if l2_error < best_error
            best_error = l2_error;
            best_patch = patch;
        end
    end
    target_top = target(1:overlap_top_size(1), :, : );
    target_left = target(:, 1:overlap_left_size(2), :);
    best_patch = left_overlap_cut(best_patch, overlap_left, alpha, target_left);
    best_patch = top_overlap_cut(best_patch, overlap_top, alpha, target_top);
end
