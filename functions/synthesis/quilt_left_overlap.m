function [ best_patch ] = quilt_left_overlap(overlap, Im, patch_size, iters, target, alpha, mode, pt)
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
        %sum = 0;
        error_sum = norm(overlap_error(:))^2;
        if ~(mode == 0)
            v1 = single(pt(:,overlap_size(2)+1:end,:));
            v1 = v1 - single(patch(:,overlap_size(2)+1:end,:));
            error_sum = error_sum + norm(v1(:))^2;
        end 
        V1 = mean(single(target), 3);
        V2 = mean(single(patch), 3);
        corr_err = sum(sum((V1 - V2).^2));
        %for j = 1:patch_size(1)
        %    for k = 1:patch_size(2)
        %        v1 = sum(reshape(single(target(j, k, :)), [3 1]))/3;
        %        v2 = sum(reshape(single(patch(j, k, :)), [3 1]))/3;
        %        temp = (v1 - v2)^2;
        %        if mode == 1
        %            v3 = sum(reshape(single(send_t(j, k, :)), [3 1]))/3;
        %            temp = temp * beta + (1 - beta) * (v3 - v2)^2;
        %        end
        %        sum = sum + temp;
        %    end
        %end
        l2_error = alpha * sqrt(error_sum) + (1 - alpha) * corr_err;
        if l2_error < best_error
            best_error = l2_error;
            best_patch = patch;
        end
    end
    target_left = target(:, 1:overlap_size(2), :);
    best_patch = left_overlap_cut(best_patch, overlap, alpha, target_left);
end
